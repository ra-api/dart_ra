import '../../method.dart';
import '../../package.dart';
import 'spec_method.dart';

final class CorePackage extends Package {
  const CorePackage();
  @override
  List<Method> get methods {
    return [
      SpecMethod(),
    ];
  }

  @override
  String get name => 'core';
}
