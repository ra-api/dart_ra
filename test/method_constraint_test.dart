import 'package:mab/mab.dart';
import 'package:test/test.dart';

void main() {
  group('MethodConstraint tests', () {
    test('allow', () {
      final constraint = MethodConstraint<_Method>.allow();
      expect(constraint.allow(_Method()), equals(true));
    });

    test('deny', () {
      final constraint = MethodConstraint<_Method>.deny();
      expect(constraint.allow(_Method()), equals(false));
    });
  });
}

final class _Method extends Method {
  @override
  ResponseContentType<Object> get contentType => throw UnimplementedError();

  @override
  Future<MethodResponse> handle(MethodCtx ctx) {
    throw UnimplementedError();
  }

  @override
  String get name => throw UnimplementedError();
}
