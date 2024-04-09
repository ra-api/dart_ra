import 'package:meta/meta.dart';
import 'package:ra/src/core/method/method.dart';
import 'package:ra/src/core/parameter/parameter.dart';
import 'package:ra/src/core/plugin/plugin.dart';
import 'package:ra/src/core/plugin/plugin_registry.dart';
import 'package:ra/src/package.dart';
import 'package:ra/src/types.dart';

@immutable
final class Registry {
  final double currentApiVersion;
  final List<Package> packages;
  final List<Plugin> plugins;
  final List<RegistryItem> _methods = [];

  Registry({
    required this.packages,
    required this.currentApiVersion,
    required this.plugins,
  }) {
    for (final package in packages) {
      if (package.methods.isEmpty) {
        continue;
      }
      if (package.methods.length > 1) {
        for (final method in package.methods) {
          _addToRegistry(package: package, method: method);
        }
      } else if (package.methods.length == 1) {
        final method = package.methods.first;
        _addToRegistry(package: package, method: method);
      }
    }

    _methods.sort((a, b) {
      return b.key.compareTo(a.key);
    });
  }

  void _addToRegistry({required Package package, required Method method}) {
    for (var plugin in method.plugins) {
      if (plugin is PluginProvider) {
        throw ArgumentError(
          'Invalid plugin ${plugin.runtimeType} in method ${method.runtimeType}, '
          'available plugin types for method: Plugin or PluginConsumer',
        );
      }
    }

    _methods.add(
      RegistryItem(
        key: _key(
          package: package.name,
          method: method.name,
          version: method.version,
        ),
        httpMethod: _httpMethod(method),
        method: method,
        package: package,
        version: method.version ?? currentApiVersion,
        plugins: plugins,
      ),
    );
  }

  String _httpMethod(Method method) {
    try {
      method.params.firstWhere((element) {
        return element.source == MethodDataSource.body;
      });
      return 'POST';
    } on Object {
      return 'GET';
    }
  }

  List<RegistryItem> get methods => List.unmodifiable(_methods);

  List<double> availableVersions({
    required String package,
    required String method,
  }) {
    return _methods
        .where((e) => e.package.name == package && e.method.name == method)
        .map((e) => e.method.version ?? currentApiVersion)
        .toList(growable: false);
  }

  RegistryItem? find({
    required String package,
    required String method,
    required double version,
  }) {
    try {
      final key = _key(package: package, method: method, version: version);
      return _methods.firstWhere((e) => e.key == key);
    } on StateError {
      return null;
    }
  }

  String _key({
    required String package,
    required String method,
    double? version,
  }) {
    final newVersion = version ?? currentApiVersion;

    return '$package.$method+$newVersion';
  }
}

@immutable
final class RegistryItem {
  final String key;
  final Package package;
  final Method method;
  final double version;
  final String httpMethod;
  final Iterable<Plugin> plugins;

  const RegistryItem({
    required this.key,
    required this.method,
    required this.package,
    required this.version,
    required this.httpMethod,
    required this.plugins,
  });

  PluginRegistry get pluginRegistry {
    final pluginsData = [
      ...plugins.map((e) {
        return PluginData(plugin: e, scope: PluginScope.global);
      }),
      ...method.plugins.map((e) {
        return PluginData(plugin: e, scope: PluginScope.method);
      }),
    ];
    return PluginRegistry(plugins: pluginsData);
  }

  List<Parameter> get params {
    final packageParams = package.params.where((element) {
      if (element.constraints?.isNotEmpty == true) {
        bool res = false;
        for (final constraint in element.constraints!) {
          if (constraint.allow(method)) {
            res = true;
            break;
          }
        }

        return res;
      }

      return true;
    }).toList(growable: false);

    return [
      ...method.params,
      ...packageParams,
    ];
  }
}
