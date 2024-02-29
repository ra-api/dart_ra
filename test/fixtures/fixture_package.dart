import 'package:mab/mab.dart';

final class FixturePackage extends Package {
  final String? fakeName;

  final List<Method>? fakeMethods;
  final List<PackageParameter>? fakeParams;

  const FixturePackage({
    this.fakeName,
    this.fakeMethods,
    this.fakeParams,
  });

  @override
  List<Method> get methods {
    if (fakeMethods != null) {
      return fakeMethods!;
    }

    throw UnimplementedError();
  }

  @override
  String get name {
    if (fakeName != null) {
      return fakeName!;
    }
    throw UnimplementedError();
  }

  @override
  List<PackageParameter> get params {
    if (fakeParams != null) {
      return fakeParams!;
    }
    return super.params;
  }
}
