import 'dart:convert';

import 'package:mab/mab.dart';
import 'package:test/test.dart';

void main() {
  group('ModelBodyDataType tests', () {
    final dataType = ModelBodyDataType(onTransform: _Foo.from);

    test('Success convert', () async {
      final jsonStr = '{"bar": "baz"}';
      final res = await dataType.convert(utf8.encode(jsonStr));
      expect(res.bar, equals('baz'));
    });

    test('Failed convert', () async {
      final payload = utf8.encode('hello world');
      expect(
        () => dataType.convert(payload),
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
