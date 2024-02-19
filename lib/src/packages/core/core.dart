import '../../method.dart';
import '../../package.dart';
import '../../registry.dart';
import 'spec_method.dart';

final class CorePackage extends Package {
  final List<RegistryItem> decls;

  CorePackage({required this.decls});
  @override
  List<Method> get methods {
    return [
      SpecMethod(decls: decls),
    ];
  }

  @override
  String get name => 'core';
}
