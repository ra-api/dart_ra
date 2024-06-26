import 'package:meta/meta.dart';
import 'package:ra/ra.dart';

@immutable
final class FixtureMethod extends Method {
  final String? fakeName;
  final List<Parameter>? fakeParams;
  final ResponseContentType? fakeContentType;

  const FixtureMethod({
    this.fakeName,
    this.fakeContentType,
    this.fakeParams,
  });
  @override
  ResponseContentType get contentType => _fake(fakeContentType);

  @override
  Future<MethodResponse> handle(MethodContext ctx) {
    throw UnimplementedError();
  }

  @override
  String get name => _fake(fakeName);

  @override
  List<Parameter> get params => _fake(fakeParams ?? []);

  T _fake<T>(T? value) => value ?? (throw UnimplementedError());
}
