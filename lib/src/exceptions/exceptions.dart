library exceptions;

import 'package:mab/mab.dart';
import 'package:mab/src/parameter.dart';

part 'data_type.dart';
part 'data_type_validate.dart';
part 'method_context_cast.dart';
part 'method_context_invalid_id.dart';
part 'method_not_found.dart';
part 'wrong_method_version.dart';

abstract base class ApiException implements Exception {
  final int statusCode;

  const ApiException({required this.statusCode});

  String get reason;

  JsonType? get extraFields => null;
  JsonType? get verboseFields => null;
}
