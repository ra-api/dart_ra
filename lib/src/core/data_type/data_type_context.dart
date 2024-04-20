import 'package:meta/meta.dart';
import 'package:ra/src/core/plugin/plugin.dart';
import 'package:ra/src/core/plugin/plugin_registry.dart';

/// Context class for data types, used for accessing plugin options.
@immutable
class DataTypeContext {
  final PluginRegistry _pluginRegistry;

  /// Constructs a DataTypeContext with the specified plugin registry.
  const DataTypeContext({
    required PluginRegistry pluginRegistry,
  }) : _pluginRegistry = pluginRegistry;

  /// Gets the options for the specified plugin type.
  T options<T extends PluginOptions>() {
    return _pluginRegistry.options<T>();
  }
}
