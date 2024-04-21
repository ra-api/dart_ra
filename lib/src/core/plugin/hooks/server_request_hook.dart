part of 'hooks.dart';

/// Represents a server request event.
@immutable
class ServerRequestEvent {
  /// The request context associated with the event.
  final ServerRequest request;

  /// Constructs a [ServerRequestEvent] with the specified request context.
  const ServerRequestEvent({
    required this.request,
  });
}

/// Abstract interface for server request hooks.
@immutable
abstract class ServerRequestHook extends PluginHook {
  const ServerRequestHook();

  /// Handles the server request event.
  @internal
  FutureOr<ServerRequest> onServerRequest(ServerRequestEvent event);
}
