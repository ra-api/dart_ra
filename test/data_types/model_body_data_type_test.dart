import 'dart:convert';

import 'package:ra_core/mab.dart';
import 'package:test/test.dart';

import '../fixtures/fixture_data_type_context.dart';

void main() {
  group('ModelBodyDataType tests', () {
    final dataType = ModelBodyDataType(onTransform: _Foo.from);

    test('Success convert', () async {
      final jsonStr = '{"bar": "baz"}';
      final ctx = fixtureDataTypeCtx();
      final res = await dataType.convert(utf8.encode(jsonStr), ctx);
      expect(res.bar, equals('baz'));
    });

    test('Failed convert', () async {
      final ctx = fixtureDataTypeCtx();
      expect(
        () => dataType.convert(utf8.encode('hello world'), ctx),
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
