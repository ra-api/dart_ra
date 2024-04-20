import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ra/src/core/server/server_request.dart';
import 'package:ra/src/core/server/server_response.dart';

/// Callback signature for request handling.
typedef HandlerCallback = Future<ServerResponse> Function(
    ServerRequest request);

/// Base class for server providers.
@immutable
abstract class ServerProvider {
  final int port;

  /// Constructs a [ServerProvider] with the specified [port].
  const ServerProvider({required this.port});

  /// Initializes the server with the provided [handler].
  ///
  /// This method should be overridden by subclasses to start the server
  /// and handle incoming requests.
  @mustCallSuper
  Future<void> init(HandlerCallback handler);
}
