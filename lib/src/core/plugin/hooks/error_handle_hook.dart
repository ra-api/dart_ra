part of 'hooks.dart';

final class ErrorHandleEvent {
  final ApiException exception;
  final StackTrace stackTrace;

  ErrorHandleEvent({
    required this.exception,
    required this.stackTrace,
  });
}

@immutable
abstract interface class ErrorHandleHook extends PluginHook {
  const ErrorHandleHook();

  @internal
  void onErrorHandle(ErrorHandleEvent event);
}
