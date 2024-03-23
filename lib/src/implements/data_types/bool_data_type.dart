part of 'data_types.dart';

@immutable
class BoolDataType extends DataType<String, bool> {
  const BoolDataType({super.initial});
  @override
  String get summary {
    final positive = _positive.join(', ');
    final negative = _negative.join(', ');

    return 'Convert String value to boolean, positive: '
        '$positive, negative: $negative';
  }

  @override
  FutureOr<bool> convert(DataTypeContext<String> ctx) {
    final allowed = <String>{
      ..._positive,
      ..._negative,
    };
    final str = ctx.data.toLowerCase();
    if (!allowed.contains(str)) {
      throw DataTypeValidateException(dataType: this);
    }

    return _positive.contains(str);
  }

  Set<String> get _positive {
    return {'true', '1', 'on', 'y', 'yes'};
  }

  Set<String> get _negative {
    return {'false', '0', 'off', 'n', 'no'};
  }
}
