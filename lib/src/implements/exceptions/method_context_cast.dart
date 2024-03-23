part of 'exceptions.dart';

final class MethodContextCastException extends ApiException {
  final Type actual;
  final Type expected;

  const MethodContextCastException({
    required this.actual,
    required this.expected,
  }) : super(statusCode: 500, reported: true);

  @override
  String get reason {
    return 'Context value cast error';
  }

  @override
  JsonType? get verboseFields {
    return {
      'actual': actual.toString(),
      'expected': expected.toString(),
    };
  }
}
