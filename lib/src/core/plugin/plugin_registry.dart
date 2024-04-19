import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ra/src/core/plugin/plugin.dart';
import 'package:ra/src/core/request_context.dart';
import 'package:ra/src/core/response_context.dart';
import 'package:ra/src/types.dart';

@internal
@immutable
final class PluginRegistry {
  final Iterable<PluginData> _plugins;

  const PluginRegistry({
    required Iterable<PluginData> plugins,
  }) : _plugins = plugins;

  T provider<T extends PluginProvider>() {
    print(T.runtimeType);
    return _plugins.map((e) => e.plugin).whereType<T>().first;
  }

  T options<T extends PluginOptions>() {
    return _plugins
        .map((e) => e.plugin)
        .whereType<PluginProvider<T>>()
        .first
        .options;
  }

  List<T> _pluginByHook<T extends PluginHook>(Set<PluginScope> scopes) {
    return _plugins
        .where((element) => scopes.contains(element.scope))
        .map((e) => e.plugin)
        .whereType<T>()
        .toList(growable: false);
  }

  void performErrorHandle(ErrorHandleEvent event) {
    final plugins = _pluginByHook<ErrorHandleHook>({
      PluginScope.global,
      PluginScope.method,
    });

    for (final hook in plugins) {
      hook.onErrorHandle(event);
    }
  }

  FutureOr<ResponseCtx> performMethodResponse(MethodResponseEvent event) async {
    final plugins = _pluginByHook<MethodResponseHook>({
      PluginScope.global,
      PluginScope.method,
    });
    var response = event.response;
    for (final hook in plugins) {
      response = await hook.onMethodResponse(
        MethodResponseEvent(
          request: event.request,
          response: response,
        ),
      );
    }

    return response;
  }

  FutureOr<RequestCtx> performMethodRequest(MethodRequestEvent event) async {
    final plugins = _pluginByHook<MethodRequestHook>({
      PluginScope.global,
      PluginScope.method,
    });
    var request = event.request;
    for (final hook in plugins) {
      request = await hook.onMethodRequest(
        MethodRequestEvent(request: event.request),
      );
    }

    return request;
  }
}
