import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ra/src/core/api_exception.dart';
import 'package:ra/src/core/data_type/data_type_context.dart';
import 'package:ra/src/core/method/data_source_context.dart';
import 'package:ra/src/core/method/method_context.dart';
import 'package:ra/src/core/method/method_decl.dart';
import 'package:ra/src/core/method/method_response.dart';
import 'package:ra/src/core/plugin/plugin.dart';
import 'package:ra/src/core/plugin/plugin_registry.dart';
import 'package:ra/src/core/registry.dart';
import 'package:ra/src/core/server/server.dart';
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
    required ServerRequest ctx,
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

  Future<ServerResponse> handle({
    required ServerRequest ctx,
    required String baseEndpoint,
  }) async {
    RegistryItem? handler;
    try {
      _checkBaseEndpoint(uri: ctx.uri, baseEndpoint: baseEndpoint);
      handler = _findMethod(ctx: ctx, baseEndpoint: baseEndpoint);

      final newRequest = await handler.pluginRegistry.performMethodRequest(
        MethodRequestEvent(request: ctx),
      );

      final methodCtx =
          await _methodContext(handler: handler, request: newRequest);
      var methodResponse = (await handler.method.handle(methodCtx))
        ..decl(MethodDecl(handler));

      return await handler.pluginRegistry.performMethodResponse(
        MethodResponseEvent(
          request: ctx,
          response: methodResponse.build(),
        ),
      );
    } catch (error, stackTrace) {
      final registry =
          handler != null ? handler.pluginRegistry : _globalPluginRegistry;

      final exception = error is ApiException
          ? error
          : ServerInternalException(
              reason: 'Method unexpected internal error',
              error: error,
              stackTrace: stackTrace,
            );

      registry.performErrorHandle(
        ErrorHandleEvent(
          exception: exception,
          stackTrace: stackTrace,
        ),
      );
      return _apiErrorResponse(
        exception: exception,
        request: ctx,
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

  FutureOr<ServerResponse> _apiErrorResponse({
    required ApiException exception,
    required ServerRequest request,
  }) async {
    final body = {
      'error': {
        'message': exception.reason,
        ...exception.extraFields ?? {},
        if (verbose) ...{'verbose': exception.verboseFields},
      },
    };

    final methodResponse = MethodResponse<JsonType>(JsonContentType())
      ..statusCode(exception.statusCode)
      ..headers(exception.headers)
      ..body(body);

    return await _globalPluginRegistry.performMethodResponse(
      MethodResponseEvent(
        request: request,
        response: methodResponse.build(),
      ),
    );
  }

  Future<MethodContext> _methodContext({
    required RegistryItem handler,
    required ServerRequest request,
  }) async {
    final methodCtx = <String, dynamic>{};

    final dataSourceCtx = DataSourceContext(
      headers: request.headers,
      queries: request.queries,
      body: request.body,
    );

    for (final paramData in handler.paramsData) {
      final raw = await paramData.parameter.extract(dataSourceCtx);

      try {
        final val = (raw == null && !paramData.parameter.isRequired)
            ? paramData.parameter.dataType.initial
            : await paramData.parameter.dataType.convert(
                raw,
                DataTypeContext(
                  pluginRegistry: handler.pluginRegistry,
                ));
        methodCtx.putIfAbsent(paramData.parameter.id, () => val);
      } on ApiException {
        rethrow;
      } on Object catch (e, st) {
        throw Error.throwWithStackTrace(
          DataTypeException(parameter: paramData.parameter),
          st,
        );
      }
    }

    final methods =
        _registry.methods.map(MethodDecl.new).toList(growable: false);

    return MethodContext(
      methodCtx,
      methods: methods,
      current: MethodDecl(handler),
      verbose: verbose,
      pluginRegistry: handler.pluginRegistry,
    );
  }

  double _version(ServerRequest request) {
    final queryVersion = request.uri.queryParameters['v'];
    if (queryVersion == null) {
      return currentApiVersion;
    }

    return double.tryParse(queryVersion) ?? currentApiVersion;
  }
}
