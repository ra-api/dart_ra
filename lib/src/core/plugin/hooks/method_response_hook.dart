part of 'hooks.dart';

/// Represents a method response event.
@immutable
class MethodResponseEvent {
  /// The request context associated with the event.
  final RequestContext request;

  /// The response context associated with the event.
  final ResponseContext response;

  /// Constructs a [MethodResponseEvent] with the specified request and response contexts.
  const MethodResponseEvent({
    required this.request,
    required this.response,
  });
}

/// Abstract interface for method response hooks.
@immutable
abstract class MethodResponseHook extends PluginHook {
  const MethodResponseHook();

  /// Handles the method response event.
  @internal
  FutureOr<ResponseContext> onMethodResponse(MethodResponseEvent event);
}
