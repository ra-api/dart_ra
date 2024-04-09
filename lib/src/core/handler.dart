import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ra/src/core/data_type/data_type_context.dart';
import 'package:ra/src/core/method/data_source_context.dart';
import 'package:ra/src/core/method/method_context.dart';
import 'package:ra/src/core/method/method_decl.dart';
import 'package:ra/src/core/method/method_response.dart';
import 'package:ra/src/core/plugin/plugin.dart';
import 'package:ra/src/core/plugin/plugin_registry.dart';
import 'package:ra/src/core/registry.dart';
import 'package:ra/src/core/request_context.dart';
import 'package:ra/src/core/response_context.dart';
import 'package:ra/src/implements/content_types/content_types.dart';
import 'package:ra/src/implements/exceptions/exceptions.dart';
import 'package:ra/src/package.dart';
import 'package:ra/src/types.dart';

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

  PluginRegistry get _globalPluginRegistry {
    return PluginRegistry(
      plugins: plugins.map(
        (e) => PluginData(plugin: e, scope: PluginScope.global),
      ),
    );
  }

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

  Future<ResponseCtx> handle({
    required RequestCtx ctx,
    required String baseEndpoint,
  }) async {
    try {
      _checkBaseEndpoint(uri: ctx.uri, baseEndpoint: baseEndpoint);

      final handler = _findMethod(ctx: ctx, baseEndpoint: baseEndpoint);

      final request = await handler.pluginRegistry.performMethodRequest(
        MethodRequestEvent(request: ctx),
      );

      final methodCtx = await _methodContext(handler: handler, reqCtx: request);
      var methodResponse = (await handler.method.handle(methodCtx))
        ..decl(MethodDecl(handler));

      return await handler.pluginRegistry.performMethodResponse(
        MethodResponseEvent(
          request: ctx,
          response: methodResponse.build(),
        ),
      );
    } on ApiException catch (exception, stackTrace) {
      final request = await _globalPluginRegistry.performMethodRequest(
        MethodRequestEvent(request: ctx),
      );

      _globalPluginRegistry.performErrorHandle(
        ErrorHandleEvent(
          exception: exception,
          stackTrace: stackTrace,
        ),
      );
      return _apiErrorResponse(
        exception: exception,
        request: request,
      );
    } catch (error, stackTrace) {
      final request = await _globalPluginRegistry.performMethodRequest(
        MethodRequestEvent(request: ctx),
      );

      final exception = ServerInternalException(
        reason: 'Method unexpected internal error',
        error: error,
        stackTrace: stackTrace,
      );
      _globalPluginRegistry.performErrorHandle(
        ErrorHandleEvent(
          exception: exception,
          stackTrace: stackTrace,
        ),
      );
      return _apiErrorResponse(
        exception: exception,
        request: request,
      );
    }
  }

  void _checkBaseEndpoint({required Uri uri, required String baseEndpoint}) {
    if (!uri.path.startsWith('$baseEndpoint/')) {
      throw ServerNotImplementedException(
        reason: 'Route must be format $baseEndpoint/',
      );
    }
  }

  FutureOr<ResponseCtx> _apiErrorResponse(
      {required ApiException exception, required RequestCtx request}) async {
    final body = {
      'error': {
        'message': exception.reason,
        ...exception.extraFields ?? {},
        if (verbose) ...{'verbose': exception.verboseFields},
      },
    };

    final methodResponse = MethodResponse<JsonType>(JsonContentType())
      ..statusCode(exception.statusCode)
      ..body(body);

    return await _globalPluginRegistry.performMethodResponse(
      MethodResponseEvent(
        request: request,
        response: methodResponse.build(),
      ),
    );
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
