part of 'exceptions.dart';

final class ServerNotImplementedException extends ApiException {
  final String _verboseReason;

  const ServerNotImplementedException({required String reason})
      : _verboseReason = reason,
        super(statusCode: 501, reported: true);

  @override
  String get reason => 'Not implemented';

  @override
  JsonType? get verboseFields {
    return {'reason': _verboseReason};
  }
}
