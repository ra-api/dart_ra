import 'package:mab/src/plugin/plugin.dart';
import 'package:mab/src/plugin/plugin_providers.dart';

class PluginProviderSingleton {
  static final PluginProviderSingleton _singleton = PluginProviderSingleton._();

  factory PluginProviderSingleton.instance() {
    return _singleton;
  }

  final _providers = PluginProviders(providers: []);

  T provider<T extends PluginProvider>() {
    return _providers.provider<T>();
  }

  void init(Iterable<Plugin> providers) {
    _providers.init(providers);
  }

  PluginProviderSingleton._();
}
