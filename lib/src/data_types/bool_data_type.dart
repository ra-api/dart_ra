import 'dart:async';

import 'package:mab/src/data_type.dart';

class BoolDataType extends DataType<String, bool> {
  @override
  String get summary {
    final positive = _positive.join(', ');
    final negative = _negative.join(', ');

    return 'Convert String value to boolean, positive: '
        '$positive, negative: $negative';
  }

  @override
  FutureOr<bool> convert(String data) {
    final allowed = <String>{
      ..._positive,
      ..._negative,
    };
    final str = data.toLowerCase();
    if (!allowed.contains(str)) {
      throw Exception();
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
