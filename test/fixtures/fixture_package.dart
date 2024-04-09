import 'package:ra/ra.dart';

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
  List<Method> get methods => _fake(fakeMethods);

  @override
  String get name => _fake(fakeName);

  @override
  List<PackageParameter> get params => _fake(fakeParams);

  T _fake<T>(T? value) => value ?? (throw UnimplementedError());
}
