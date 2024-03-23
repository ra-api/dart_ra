import 'package:mab/src/core/plugin/plugin.dart';
import 'package:mab/src/core/plugin/plugin_providers.dart';
import 'package:meta/meta.dart';

@immutable
final class DataTypeContext<I> {
  final I data;
  final PluginProviders _pluginProviders;

  const DataTypeContext({
    required this.data,
    required PluginProviders pluginProviders,
  }) : _pluginProviders = pluginProviders;

  T plugin<T extends PluginProvider>() {
    return _pluginProviders.provider<T>();
  }
}
