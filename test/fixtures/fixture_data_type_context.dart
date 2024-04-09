import 'package:ra_core/src/core/data_type/data_type_context.dart';
import 'package:ra_core/src/core/plugin/plugin.dart';
import 'package:ra_core/src/core/plugin/plugin_registry.dart';

DataTypeCtx fixtureDataTypeCtx<T>({
  List<PluginData> plugins = const [],
}) {
  return DataTypeCtx(
    pluginRegistry: PluginRegistry(
      plugins: plugins,
    ),
  );
}
