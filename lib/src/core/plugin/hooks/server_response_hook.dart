part of 'hooks.dart';

/// Represents a server response event.
@immutable
class ServerResponseEvent {
  /// The request context associated with the event.
  final ServerRequest request;

  /// The response context associated with the event.
  final ServerResponse response;

  /// Constructs a [ServerResponseEvent] with the specified request and response contexts.
  const ServerResponseEvent({
    required this.request,
    required this.response,
  });
}

/// Abstract interface for server response hooks.
@immutable
abstract class ServerResponseHook extends PluginHook {
  const ServerResponseHook();

  /// Handles the server response event.
  @internal
  FutureOr<ServerResponse> onServerResponse(ServerResponseEvent event);
}
