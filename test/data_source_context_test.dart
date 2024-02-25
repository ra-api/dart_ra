import 'dart:convert';

import 'package:mab/src/data_source_context.dart';
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

    test('body', () async {
      expect(await ctx.body(), equals(utf8.encode('foo')));
    });
  });
}

Stream<List<int>> _body(String data) {
  final bytes = utf8.encode(data);
  return Stream<List<int>>.value(List<int>.from(bytes));
}
