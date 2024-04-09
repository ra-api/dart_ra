import 'package:meta/meta.dart';
import 'package:ra/src/core/plugin/plugin.dart';
import 'package:ra/src/core/plugin/plugin_registry.dart';

@immutable
final class DataTypeCtx {
  final PluginRegistry _pluginRegistry;

  const DataTypeCtx({
    required PluginRegistry pluginRegistry,
  }) : _pluginRegistry = pluginRegistry;

  T options<T extends PluginOptions>() {
    return _pluginRegistry.options<T>();
  }
}
