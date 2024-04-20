import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ra/src/core/plugin/plugin.dart';
import 'package:ra/src/core/server/server.dart';
import 'package:ra/src/types.dart';

/// A registry for managing plugins and handling plugin-related events.
@internal
@immutable
class PluginRegistry {
  final Iterable<PluginData> _plugins;

  /// Constructs a [PluginRegistry] with the specified plugins.
  const PluginRegistry({
    required Iterable<PluginData> plugins,
  }) : _plugins = plugins;

  /// Retrieves the provider of the specified plugin type [T].
  ///
  /// This method returns the first plugin of type [T].
  T provider<T extends PluginProvider>() {
    return _plugins.map((e) => e.plugin).whereType<T>().first;
  }

  /// Retrieves the options of the specified plugin options type [T].
  ///
  /// This method returns the options associated with the first plugin provider of type [PluginProvider<T>].
  T options<T extends PluginOptions>() {
    return _plugins
        .map((e) => e.plugin)
        .whereType<PluginProvider<T>>()
        .first
        .options;
  }

  /// Retrieves plugins that implement a specific hook type [T] for the given set of plugin scopes.
  List<T> _pluginByHook<T extends PluginHook>(Set<PluginScope> scopes) {
    return _plugins
        .where((element) => scopes.contains(element.scope))
        .map((e) => e.plugin)
        .whereType<T>()
        .toList(growable: false);
  }

  /// Performs error handling for the given error handle event.
  void performErrorHandle(ErrorHandleEvent event) {
    final plugins = _pluginByHook<ErrorHandleHook>({
      PluginScope.global,
      PluginScope.method,
    });

    for (final hook in plugins) {
      hook.onErrorHandle(event);
    }
  }

  /// Performs method response handling for the given method response event.
  FutureOr<ServerResponse> performMethodResponse(
      MethodResponseEvent event) async {
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

  /// Performs method request handling for the given method request event.
  FutureOr<ServerRequest> performMethodRequest(MethodRequestEvent event) async {
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
