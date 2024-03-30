import 'dart:async';

import 'package:mab/src/core/plugin/plugin.dart';
import 'package:mab/src/core/response_context.dart';
import 'package:mab/src/types.dart';
import 'package:meta/meta.dart';

@internal
@immutable
final class PluginRegistry {
  final Iterable<PluginData> _plugins;

  const PluginRegistry({
    required Iterable<PluginData> plugins,
  }) : _plugins = plugins;

  T provider<T extends PluginProvider>() {
    return _plugins.whereType<T>().first;
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
}
