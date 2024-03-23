library exceptions;

import 'package:mab/src/core/data_type/data_type.dart';
import 'package:mab/src/core/parameter/method_parameter.dart';
import 'package:mab/src/core/parameter/parameter.dart';
import 'package:mab/src/types.dart';

part 'data_type.dart';
part 'data_type_validate.dart';
part 'method_context_cast.dart';
part 'method_context_invalid_id.dart';
part 'method_not_allowed.dart';
part 'method_not_found.dart';
part 'server_not_implemented.dart';
part 'wrong_method_version.dart';

abstract base class ApiException implements Exception {
  final int statusCode;
  final bool reported;

  const ApiException({required this.statusCode, this.reported = false});

  String get reason;

  JsonType? get extraFields => null;
  JsonType? get verboseFields => null;
}
