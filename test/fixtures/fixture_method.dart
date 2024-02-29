import 'package:mab/mab.dart';
import 'package:meta/meta.dart';

@immutable
final class FixtureMethod extends Method {
  final String? fakeName;
  final ResponseContentType? fakeContentType;

  const FixtureMethod({this.fakeName, this.fakeContentType});
  @override
  ResponseContentType get contentType => _fake(fakeContentType);

  @override
  Future<MethodResponse> handle(MethodContext ctx) {
    throw UnimplementedError();
  }

  @override
  String get name => _fake(fakeName);

  T _fake<T>(T? value) => value ?? (throw UnimplementedError());
}
