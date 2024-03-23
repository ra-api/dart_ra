part of 'exceptions.dart';

final class MethodNotFoundException extends ApiException {
  const MethodNotFoundException() : super(statusCode: 404);

  @override
  String get reason {
    return 'Method not found';
  }
}
