import 'package:mab/src/core/plugin/plugin.dart';
import 'package:mab/src/core/plugin/plugin_registry.dart';
import 'package:meta/meta.dart';

@immutable
final class DataTypeCtx {
  final PluginRegistry _pluginRegistry;

  const DataTypeCtx({
    required PluginRegistry pluginRegistry,
  }) : _pluginRegistry = pluginRegistry;

  T plugin<T extends PluginProvider>() {
    return _pluginRegistry.provider<T>();
  }
}
