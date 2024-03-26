library;

import 'package:mab/src/core/plugin/plugin_provider_singleton.dart';

export 'plugin_events.dart';

abstract base class Plugin {
  const Plugin();
}

abstract base class PluginOptions {}

abstract base class PluginProvider<O extends PluginOptions> extends Plugin {
  final O options;
  const PluginProvider({required this.options});
}

abstract base class PluginConsumer<T extends PluginOptions> extends Plugin {
  const PluginConsumer();

  T get options {
    return PluginProviderSingleton.instance().options<T>();
  }
}
