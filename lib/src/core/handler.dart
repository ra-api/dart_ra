import 'package:mab/mab.dart';
import 'package:mab/src/core/data_type/data_type_context.dart';
import 'package:mab/src/core/method/data_source_context.dart';
import 'package:mab/src/core/plugin/plugin.dart';
import 'package:mab/src/core/plugin/plugin_registry.dart';
import 'package:mab/src/types.dart';
import 'package:meta/meta.dart';

import 'registry.dart';
import 'request_context.dart';

/// Класс отвечающий за инициализацию [Registry], и дальнейший поиск метода
/// по пакету, имени и версии
@immutable
final class ApiHandler {
  /// Текущая актуальная версия, если в методе не указана версия,
  /// то ему будет присвоена [currentApiVersion]
  final double currentApiVersion;
  final bool verbose;

  /// Пакеты с которыми запускается сервер
  final List<Package> packages;
  final List<Plugin> plugins;

  /// Реестр методов, представление дерева в список
  final Registry _registry;

  ApiHandler({
    required this.currentApiVersion,
    required this.packages,
    required this.verbose,
    required this.plugins,
  }) : _registry = Registry(
          packages: packages,
          currentApiVersion: currentApiVersion,
          plugins: plugins,
        );

  RegistryItem _findMethod({
    required RequestCtx ctx,
    required String baseEndpoint,
  }) {
    final path = ctx.uri.path.substring(baseEndpoint.length + 1).split('.');
    final method = path.removeLast();
    final package = path.join('.');

    final version = _version(ctx);

    final handler = _registry.find(
      package: package,
      method: method,
      version: version,
    );

    if (handler == null) {
      final versions = _registry.availableVersions(
        package: package,
        method: method,
      );

      if (versions.isEmpty) {
        throw MethodNotFoundException();
      } else {
        throw WrongMethodVersionException(
          invalidVersion: version,
          availableVersions: versions,
        );
      }
    }

    if (handler.httpMethod != ctx.httpMethod) {
      throw MethodNotAllowed();
    }

    return handler;
  }

  Future<MethodResponse> handle({
    required RequestCtx ctx,
    required String baseEndpoint,
  }) async {
    try {
      _checkBaseEndpoint(uri: ctx.uri, baseEndpoint: baseEndpoint);

      final handler = _findMethod(ctx: ctx, baseEndpoint: baseEndpoint);
      final methodCtx = await _methodContext(handler: handler, reqCtx: ctx);

      return (await handler.method.handle(methodCtx))
        ..decl(MethodDecl(handler));
    } on ApiException catch (exception, stackTrace) {
      _performEventErrorHandle(
        ErrorHandleEvent(
          exception: exception,
          stackTrace: stackTrace,
        ),
      );
      return _apiErrorResponse(exception);
    } catch (error, stackTrace) {
      final exception = ServerInternalException(
        reason: 'Method unexpected internal error',
        error: error,
        stackTrace: stackTrace,
      );
      _performEventErrorHandle(
        ErrorHandleEvent(
          exception: exception,
          stackTrace: stackTrace,
        ),
      );
      return _apiErrorResponse(exception);
    }
  }

  void _performEventErrorHandle(ErrorHandleEvent event) {
    final pluginRegistry = PluginRegistry(plugins: plugins.map((e) {
      return PluginData(plugin: e, scope: PluginScope.global);
    }));
    pluginRegistry.performErrorHandle(event);
  }

  void _checkBaseEndpoint({required Uri uri, required String baseEndpoint}) {
    if (!uri.path.startsWith('$baseEndpoint/')) {
      throw ServerNotImplementedException(
        reason: 'Route must be format $baseEndpoint/',
      );
    }
  }

  MethodResponse _apiErrorResponse(ApiException exception) {
    final body = {
      'error': {
        'message': exception.reason,
        ...exception.extraFields ?? {},
        if (verbose) ...{'verbose': exception.verboseFields},
      },
    };
    return MethodResponse<JsonType>(JsonContentType())
      ..statusCode(exception.statusCode)
      ..body(body);
  }

  Future<MethodCtx> _methodContext({
    required RegistryItem handler,
    required RequestCtx reqCtx,
  }) async {
    final ctx = <String, dynamic>{};

    final dataSourceCtx = DataSourceContext(
      headers: reqCtx.headers,
      queries: reqCtx.queries,
      body: reqCtx.body,
    );

    for (final param in handler.params) {
      final raw = await param.extract(dataSourceCtx);

      try {
        final val = (raw == null && !param.isRequired)
            ? param.dataType.initial
            : await param.dataType.convert(
                raw,
                DataTypeCtx(
                  pluginRegistry: handler.pluginRegistry,
                ));
        ctx.putIfAbsent(param.id, () => val);
      } on ApiException {
        rethrow;
      } on Object catch (e, st) {
        throw Error.throwWithStackTrace(
          DataTypeException(parameter: param),
          st,
        );
      }
    }

    final methods =
        _registry.methods.map(MethodDecl.new).toList(growable: false);

    return MethodCtx(
      ctx,
      methods: methods,
      current: MethodDecl(handler),
      verbose: verbose,
      pluginRegistry: handler.pluginRegistry,
    );
  }

  double _version(RequestCtx ctx) {
    final queryVersion = ctx.uri.queryParameters['v'];
    if (queryVersion == null) {
      return currentApiVersion;
    }

    return double.tryParse(queryVersion) ?? currentApiVersion;
  }
}
