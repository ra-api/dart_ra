import 'package:ra/src/types.dart';

abstract base class ApiException implements Exception {
  final int statusCode;
  final bool reported;

  const ApiException({required this.statusCode, this.reported = false});

  String get reason;

  JsonType? get extraFields => null;
  JsonType? get verboseFields => null;
  Map<String, String> get headers => {};
}
