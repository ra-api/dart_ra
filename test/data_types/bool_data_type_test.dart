import 'package:mab/mab.dart';
import 'package:test/test.dart';

import '../fixtures/fixture_data_type_context.dart';

void main() {
  group('BoolDataType tests', () {
    _checkCases();
    _checkWrongCases();
  });
}

void _checkCases() {
  final cases = <String, bool>{
    'True': true,
    '1': true,
    'on': true,
    'y': true,
    'yes': true,
    'false': false,
    '0': false,
    'off': false,
    'n': false,
    'no': false,
  };

  for (var e in cases.entries) {
    _checkLogic(e.key, e.value);
  }
}

void _checkWrongCases() {
  final cases = ['tru', 'fals', 'ye', '2'];

  for (var e in cases) {
    _checkExceptions(e);
  }
}

void _checkExceptions(String input) {
  final ctx = fixtureDataTypeCtx();
  test('Check datatype logic if $input, must be throw exception', () {
    final datatype = BoolDataType();
    expect(
      () => datatype.convert(input, ctx),
      throwsA(isA<DataTypeValidateException>()),
    );
  });
}

void _checkLogic(String input, bool expected) {
  final ctx = fixtureDataTypeCtx();
  test('Check datatype logic if $input, must be expected $expected', () {
    final datatype = BoolDataType();
    final actual = datatype.convert(input, ctx);
    expect(actual, equals(expected));
  });
}
