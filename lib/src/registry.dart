import 'package:meta/meta.dart';

import 'method.dart';
import 'package.dart';
import 'packages/core/core.dart';

@immutable
final class Registry {
  final double currentApiVersion;
  final List<Package> packages;
  final List<RegistryItem> _methods = [];

  Registry({required this.packages, required this.currentApiVersion}) {
    final newPackages = [...packages, CorePackage(decls: _methods)];
    for (final package in newPackages) {
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
    _methods.add(
      RegistryItem(
        key: _key(
          package: package.name,
          method: method.name,
          version: method.version,
        ),
        method: method,
        package: package,
        version: method.version ?? currentApiVersion,
      ),
    );
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

  const RegistryItem({
    required this.key,
    required this.method,
    required this.package,
    required this.version,
  });
}
