import 'dart:core';

import 'package:meta/meta.dart';
import 'package:ra/src/core/plugin/plugin.dart';
import 'package:ra/src/core/plugin/plugin_registry.dart';

/// A singleton class for managing plugin providers.
@internal
@immutable
class PluginProviderSingleton {
  static final PluginProviderSingleton _singleton = PluginProviderSingleton._();

  /// Returns the singleton instance of [PluginProviderSingleton].
  factory PluginProviderSingleton.instance() {
    return _singleton;
  }

  late final PluginRegistry _registry;

  /// Retrieves the options of the specified plugin options type [T].
  ///
  /// This method returns the options associated with the plugin provider of type [PluginProvider<T>].
  T options<T extends PluginOptions>() {
    return _registry.provider<PluginProvider<T>>().options;
  }

  /// Initializes the plugin registry with the specified plugins.
  void init(Iterable<PluginData> plugins) {
    try {
      _registry = PluginRegistry(plugins: plugins);
    } catch (_, st) {
      throw Error.throwWithStackTrace(
        Exception('Plugin registry already initialized'),
        st,
      );
    }
  }

  PluginProviderSingleton._();
}
