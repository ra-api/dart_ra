part of 'exceptions.dart';

final class MethodNotAllowed extends ApiException {
  const MethodNotAllowed() : super(statusCode: 405);

  @override
  String get reason => 'Method not allowed';
}
