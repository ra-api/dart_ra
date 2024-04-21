part of 'exceptions.dart';

final class MethodContextNotLazyException extends ServerInternalException {
  const MethodContextNotLazyException({
    required super.error,
    required super.stackTrace,
  }) : super(reason: 'Parameter is not lazy');
}
