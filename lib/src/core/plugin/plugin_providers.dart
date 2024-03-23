import 'package:mab/src/core/plugin/plugin.dart';

class PluginProviders {
  final Iterable<Plugin> _providers;

  const PluginProviders({
    required Iterable<Plugin> providers,
  }) : _providers = providers;

  T provider<T extends PluginProvider>() {
    return _providers.whereType<T>().first;
  }

  void init(Iterable<Plugin> providers) {
    if (_providers.isNotEmpty) {
      throw Exception('Providers already initialized');
    }
    _providers.toList().addAll(providers.whereType<PluginProvider>());
  }
}
