import 'package:ra/src/core/data_type/data_type_context.dart';
import 'package:ra/src/core/plugin/plugin.dart';
import 'package:ra/src/core/plugin/plugin_registry.dart';

DataTypeCtx fixtureDataTypeCtx<T>({
  List<PluginData> plugins = const [],
}) {
  return DataTypeCtx(
    pluginRegistry: PluginRegistry(
      plugins: plugins,
    ),
  );
}
