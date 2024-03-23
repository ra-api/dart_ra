part of 'exceptions.dart';

final class MethodContextInvalidIdException extends ApiException {
  final String id;

  const MethodContextInvalidIdException({
    required this.id,
  }) : super(statusCode: 500, reported: true);

  @override
  String get reason {
    return 'Invalid method context id';
  }

  @override
  JsonType? get verboseFields {
    return {'id': id};
  }
}
