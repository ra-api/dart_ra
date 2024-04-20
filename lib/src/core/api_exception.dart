import 'package:ra/src/types.dart';

/// Abstract base class for API exceptions.
abstract class ApiException implements Exception {
  /// The HTTP status code associated with the exception.
  final int statusCode;

  /// Flag indicating whether the exception is reported.
  final bool reported;

  /// Constructs an [ApiException] with the specified [statusCode].
  ///
  /// [statusCode] is the HTTP status code of the exception.
  /// [reported] indicates whether the exception is reported (default is `false`).
  const ApiException({
    required this.statusCode,
    this.reported = false,
  });

  /// Returns a string describing the reason for the exception.
  String get reason;

  /// Additional fields to include in the response body (optional).
  JsonType? get extraFields => null;

  /// Additional verbose fields to include in the response body (optional).
  JsonType? get verboseFields => null;

  /// Additional headers to include in the response (optional).
  Map<String, String> get headers => {};
}
