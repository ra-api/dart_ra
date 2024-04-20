part of 'hooks.dart';

/// Represents a method request event.
@immutable
class MethodRequestEvent {
  /// The request context associated with the event.
  final RequestContext request;

  /// Constructs a [MethodRequestEvent] with the specified request context.
  const MethodRequestEvent({
    required this.request,
  });
}

/// Abstract interface for method request hooks.
@immutable
abstract class MethodRequestHook extends PluginHook {
  const MethodRequestHook();

  /// Handles the method request event.
  @internal
  FutureOr<RequestContext> onMethodRequest(MethodRequestEvent event);
}
