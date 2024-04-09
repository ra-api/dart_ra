import 'dart:convert';

import 'package:ra_core/mab.dart';
import 'package:test/test.dart';

void main() {
  group('JsonContentType tests', () {
    final contentType = JsonContentType();

    test('Check mime-type', () {
      expect(contentType.mimeType, equals('application/json'));
    });

    test('Success apply', () {
      final json = {'foo': 'bar'};
      final jsonBytes = utf8.encode(jsonEncode(json));
      final res = contentType.apply(json, null);
      expect(res, equals(jsonBytes));
    });
  });
}
