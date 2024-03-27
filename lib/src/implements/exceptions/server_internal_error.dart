part of 'exceptions.dart';

final class ServerInternalException extends ApiException {
  final String _verboseReason;
  final Object error;
  final StackTrace stackTrace;

  const ServerInternalException({
    required String reason,
    required this.error,
    required this.stackTrace,
  })  : _verboseReason = reason,
        super(statusCode: 500, reported: true);

  @override
  String get reason => 'Internal server error';

  @override
  JsonType? get verboseFields {
    return {
      'reason': _verboseReason,
      'stackTrace': stackTrace.toString().split('\n')..removeLast(),
    };
  }
}
