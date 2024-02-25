import 'dart:convert';

import 'package:mab/mab.dart';
import 'package:test/test.dart';

void main() {
  group('JsonBodyDataType tests', () {
    final dataType = JsonBodyDataType();

    test('Success convert', () async {
      final payload = utf8.encode('{"foo": "bar"}');
      final res = await dataType.convert(payload);
      expect(res['foo'], equals('bar'));
    });

    test('Failed convert', () async {
      final payload = utf8.encode('hello world');
      expect(() => dataType.convert(payload), throwsException);
    });
  });
}
