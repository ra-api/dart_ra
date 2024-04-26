import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ra/src/core/api_exception.dart';
import 'package:ra/src/core/extensitions/extensions.dart';
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
        ServerRequestEvent(request: ctx),
      );

      final methodCtx = await handler.buildContext(
        request: newRequest,
        verbose: verbose,
        methods: _registry.methods,
      );

      var methodResponse = await handler.method.handle(methodCtx);

      return await handler.pluginRegistry.performMethodResponse(
        ServerResponseEvent(
          request: ctx,
          response: (methodResponse..decl(methodCtx.current)).build(),
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
      ServerResponseEvent(
        request: request,
        response: methodResponse.build(),
      ),
    );
  }
  //
  // Future<MethodContext> _methodContext({
  //   required RegistryItem handler,
  //   required ServerRequest request,
  // }) async {
  //   final methodCtx = <String, dynamic>{};
  //
  //   final dataSourceCtx = DataSourceContext(
  //     headers: request.headers,
  //     queries: request.queries,
  //     body: request.body,
  //   );
  //
  //   final dataTypeCtx = DataTypeContext(
  //     pluginRegistry: handler.pluginRegistry,
  //   );
  //
  //   for (final paramData in handler.paramsData) {
  //     final parameter = paramData.parameter;
  //     if (parameter.lazy) {
  //       continue;
  //     }
  //
  //     final raw = await paramData.parameter.extract(dataSourceCtx);
  //
  //     if (parameter.optional &&
  //         parameter.dataType.initial == null &&
  //         raw == null) {
  //       methodCtx.putIfAbsent(parameter.id, () => null);
  //       continue;
  //     }
  //
  //     try {
  //       final val = (raw == null && parameter.optional)
  //           ? parameter.dataType.initial
  //           : await parameter.dataType.convert(raw, dataTypeCtx);
  //       methodCtx.putIfAbsent(parameter.id, () => val);
  //     } on ApiException {
  //       rethrow;
  //     } on Object catch (e, st) {
  //       throw Error.throwWithStackTrace(
  //         DataTypeException(parameter: parameter),
  //         st,
  //       );
  //     }
  //   }
  //
  //   final methods =
  //       _registry.methods.map(MethodDecl.new).toList(growable: false);
  //
  //   return MethodContext(
  //     methodCtx,
  //     dataSourceContext: dataSourceCtx,
  //     methods: methods,
  //     current: MethodDecl(handler),
  //     verbose: verbose,
  //     pluginRegistry: handler.pluginRegistry,
  //   );
  // }

  double _version(ServerRequest request) {
    final queryVersion = request.uri.queryParameters['v'];
    if (queryVersion == null) {
      return currentApiVersion;
    }

    return double.tryParse(queryVersion) ?? currentApiVersion;
  }
}
