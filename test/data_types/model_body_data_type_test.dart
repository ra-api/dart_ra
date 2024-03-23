import 'dart:convert';

import 'package:mab/mab.dart';
import 'package:test/test.dart';

import '../fixtures/fixture_data_type_context.dart';

void main() {
  group('ModelBodyDataType tests', () {
    final dataType = ModelBodyDataType(onTransform: _Foo.from);

    test('Success convert', () async {
      final jsonStr = '{"bar": "baz"}';
      final ctx = fixtureDataTypeCtx(utf8.encode(jsonStr));
      final res = await dataType.convert(ctx);
      expect(res.bar, equals('baz'));
    });

    test('Failed convert', () async {
      final ctx = fixtureDataTypeCtx(utf8.encode('hello world'));
      expect(
        () => dataType.convert(ctx),
        throwsA(isA<DataTypeValidateException>()),
      );
    });
  });
}

final class _Foo {
  final String bar;

  _Foo({required this.bar});

  factory _Foo.from(JsonType data) {
    return _Foo(bar: data['bar']);
  }
}
