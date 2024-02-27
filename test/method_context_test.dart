import 'package:mab/mab.dart';
import 'package:mab/src/method_decl.dart';
import 'package:mab/src/registry.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('MethodContext tests', () {
    final decl = MethodDecl(
      RegistryItem(
        key: 'key',
        method: _BarMethod(),
        package: _FooPackage(),
        version: 1,
      ),
    );
    final ctx = MethodContext(
      {
        'baz': 1,
        'limit': null,
      },
      current: decl,
      methods: [decl],
      verbose: false,
    );

    test('value', () {
      expect(
        ctx.value('baz'),
        equals(1),
        reason: 'Must be return 1 as dynamic',
      );
      expect(
        ctx.value<int>('baz'),
        equals(1),
        reason: 'Must be return 1 as int',
      );
      expect(
        () => ctx.value<bool>('baz'),
        throwsA(isA<MethodContextCastException>()),
        reason: 'Cast error must be throw MethodContextCastException',
      );

      expect(
        () => ctx.value<bool>('miss'),
        throwsA(isA<MethodContextInvalidIdException>()),
        reason:
            'Invalid id error must be throw MethodContextInvalidIdException',
      );
    });
  });
}

final class _FooPackage extends Package {
  @override
  List<Method<ResponseContentType<Object>, Object>> get methods => [];

  @override
  String get name => 'foo';
}

final class _BarMethod extends Method {
  @override
  ResponseContentType<Object> get contentType {
    throw UnimplementedError();
  }

  @override
  Future<MethodResponse<ResponseContentType<Object>, Object>> handle(
    MethodContext ctx,
  ) {
    throw UnimplementedError();
  }

  @override
  String get name => 'bar';
}
