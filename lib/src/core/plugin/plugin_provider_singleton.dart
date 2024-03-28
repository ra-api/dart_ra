import 'dart:core';

import 'package:mab/src/core/plugin/plugin.dart';
import 'package:mab/src/core/plugin/plugin_registry.dart';
import 'package:meta/meta.dart';

@internal
@immutable
class PluginProviderSingleton {
  static final PluginProviderSingleton _singleton = PluginProviderSingleton._();

  factory PluginProviderSingleton.instance() {
    return _singleton;
  }

  late final PluginRegistry _registry;

  T options<T extends PluginOptions>() {
    return _registry.provider<PluginProvider<T>>().options;
  }

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
