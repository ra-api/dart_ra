import 'package:mab/mab.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

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
            final res = await dataType.convert(testCase.input);
            expect(
              res,
              equals(testCase.expected),
            );
          },
        );
      }
    });

    test('Failed convert', () async {
      final payload = 'hello world';
      expect(
        () => dataType.convert(payload),
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