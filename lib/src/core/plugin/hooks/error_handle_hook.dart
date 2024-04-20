part of 'hooks.dart';

/// Represents an error handle event.
class ErrorHandleEvent {
  /// The API exception associated with the event.
  final ApiException exception;

  /// The stack trace associated with the event.
  final StackTrace stackTrace;

  /// Constructs an [ErrorHandleEvent] with the specified exception and stack trace.
  ErrorHandleEvent({
    required this.exception,
    required this.stackTrace,
  });
}

/// Abstract interface for error handle hooks.
@immutable
abstract class ErrorHandleHook extends PluginHook {
  const ErrorHandleHook();

  /// Handles the error handle event.
  @internal
  void onErrorHandle(ErrorHandleEvent event);
}
