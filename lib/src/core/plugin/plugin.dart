import 'package:meta/meta.dart';
import 'package:ra/src/core/plugin/plugin_provider_singleton.dart';
import 'package:ra/src/types.dart';

export 'hooks/hooks.dart';

/// Abstract base class for plugins.
@immutable
abstract class Plugin {
  const Plugin();
}

/// Abstract base class for plugin options.
@immutable
abstract class PluginOptions {
  const PluginOptions();
}

/// Abstract base class for plugin providers.
@immutable
abstract class PluginProvider<O extends PluginOptions> extends Plugin {
  /// The options associated with the plugin provider.
  final O options;

  /// Constructs a [PluginProvider] with the specified options.
  const PluginProvider({required this.options});
}

/// Abstract base class for plugin consumers.
@immutable
abstract class PluginConsumer<T extends PluginOptions> extends Plugin {
  const PluginConsumer();

  /// Retrieves the options associated with the plugin consumer.
  T get options {
    return PluginProviderSingleton.instance().options<T>();
  }
}

/// Represents data about a plugin, including the plugin itself and its scope.
@internal
@immutable
class PluginData {
  /// The plugin instance.
  final Plugin plugin;

  /// The scope of the plugin.
  final PluginScope scope;

  /// Constructs a [PluginData] with the specified plugin and scope.
  const PluginData({required this.plugin, required this.scope});
}
