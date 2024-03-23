import 'dart:core';

import 'package:mab/src/core/plugin/plugin.dart';
import 'package:mab/src/core/plugin/plugin_registry.dart';

class PluginProviderSingleton {
  static final PluginProviderSingleton _singleton = PluginProviderSingleton._();

  factory PluginProviderSingleton.instance() {
    return _singleton;
  }

  late final PluginRegistry _registry;

  T provider<T extends PluginProvider>() {
    return _registry.provider<T>();
  }

  void init(Iterable<Plugin> plugins) {
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
