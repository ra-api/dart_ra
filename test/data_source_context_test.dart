import 'dart:convert';
import 'dart:typed_data';

import 'package:ra/src/core/method/data_source_context.dart';
import 'package:test/test.dart';

void main() {
  group('DataSourceContext tests', () {
    final ctx = DataSourceContext(
      headers: {'token': 'foo'},
      body: _body('foo'),
      queries: {'limit': '1'},
    );

    test('header', () {
      expect(ctx.header('token'), equals('foo'));
      expect(ctx.header('missing'), isNull);
    });

    test('query', () {
      expect(ctx.query('limit'), equals('1'));
      expect(ctx.query('missing'), isNull);
    });

    test('body', () {
      expect(ctx.body, equals(utf8.encode('foo')));
    });
  });
}

Uint8List _body(String data) {
  final bytes = utf8.encode(data);
  return Uint8List.fromList(bytes);
}
