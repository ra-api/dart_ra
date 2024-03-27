library;

import 'package:mab/src/core/plugin/plugin_provider_singleton.dart';
import 'package:meta/meta.dart';

export 'hooks/hooks.dart';

@immutable
abstract base class Plugin {
  const Plugin();
}

@immutable
abstract base class PluginOptions {
  const PluginOptions();
}

@immutable
abstract base class PluginProvider<O extends PluginOptions> extends Plugin {
  final O options;

  const PluginProvider({required this.options});
}

@immutable
abstract base class PluginConsumer<T extends PluginOptions> extends Plugin {
  const PluginConsumer();

  T get options {
    return PluginProviderSingleton.instance().options<T>();
  }
}
