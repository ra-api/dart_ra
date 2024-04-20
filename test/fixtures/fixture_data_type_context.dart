import 'package:ra/src/core/data_type/data_type_context.dart';
import 'package:ra/src/core/plugin/plugin.dart';
import 'package:ra/src/core/plugin/plugin_registry.dart';

DataTypeContext fixtureDataTypeCtx<T>({
  List<PluginData> plugins = const [],
}) {
  return DataTypeContext(
    pluginRegistry: PluginRegistry(
      plugins: plugins,
    ),
  );
}
