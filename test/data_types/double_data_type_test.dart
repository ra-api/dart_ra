import 'package:meta/meta.dart';
import 'package:ra/ra.dart';
import 'package:test/test.dart';

import '../fixtures/fixture_data_type_context.dart';

void main() {
  group('DoubleDataType tests', () {
    final dataType = DoubleDataType();

    group('Success convert', () {
      final cases = [
        _ConvertTestCase(input: '1', expected: 1.0),
        _ConvertTestCase(input: '0', expected: 0.0),
        _ConvertTestCase(input: '-0', expected: -0.0),
        _ConvertTestCase(input: '1.5', expected: 1.5),
      ];

      for (final testCase in cases) {
        test(
          'Input ${testCase.input} expect value ${testCase.expected}',
          () async {
            final ctx = fixtureDataTypeCtx();
            final res = await dataType.convert(testCase.input, ctx);
            expect(
              res,
              equals(testCase.expected),
            );
          },
        );
      }
    });

    test('Failed convert', () async {
      final ctx = fixtureDataTypeCtx();
      expect(
        () => dataType.convert('hello world', ctx),
        throwsA(isA<DataTypeValidateException>()),
      );
    });
  });
}

@immutable
final class _ConvertTestCase {
  final String input;
  final double expected;

  const _ConvertTestCase({required this.input, required this.expected});
}
