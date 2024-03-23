import 'package:mab/src/core/data_type/data_type_context.dart';
import 'package:mab/src/core/plugin/plugin.dart';
import 'package:mab/src/core/plugin/plugin_providers.dart';

DataTypeContext<T> fixtureDataTypeCtx<T>(
  T data, {
  List<Plugin> plugins = const [],
}) {
  return DataTypeContext(
    data: data,
    pluginProviders: PluginProviders(
      providers: plugins,
    ),
  );
}
