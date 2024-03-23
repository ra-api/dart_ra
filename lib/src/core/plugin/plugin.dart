library;

import 'package:mab/src/core/plugin/plugin_provider_singleton.dart';

export 'plugin_events.dart';

abstract base class Plugin {
  const Plugin();
}

abstract base class PluginProvider extends Plugin {
  const PluginProvider();
}

abstract base class PluginConsumer<T extends PluginProvider> extends Plugin {
  const PluginConsumer();

  T provider() => PluginProviderSingleton.instance().provider<T>();
}
