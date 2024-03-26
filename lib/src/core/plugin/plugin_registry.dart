import 'package:mab/src/core/plugin/plugin.dart';
import 'package:mab/src/implements/exceptions/exceptions.dart';
import 'package:meta/meta.dart';

@immutable
final class PluginRegistry {
  final Iterable<Plugin> _plugins;

  const PluginRegistry({
    required Iterable<Plugin> plugins,
  }) : _plugins = plugins;

  T provider<T extends PluginProvider>() {
    return _plugins.whereType<T>().first;
  }

  T options<T extends PluginOptions>() {
    return _plugins.whereType<PluginProvider<T>>().first.options;
  }

  List<T> _pluginByEvent<T>() {
    return _plugins.whereType<T>().toList(growable: false);
  }

  void performErrorHandle(ApiException exception) {
    _pluginByEvent<EventErrorHandle>().forEach((element) {
      element.onErrorHandle(exception);
    });
  }
}
