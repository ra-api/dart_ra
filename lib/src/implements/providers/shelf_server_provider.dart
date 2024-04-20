import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:ra/src/core/request_context.dart';
import 'package:ra/src/core/server_provider.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

/// Type definition for the callback invoked when the server is served.
typedef OnServeCallback = void Function(HttpServer);

/// A provider for a server using the Shelf framework.
@immutable
final class ShelfServerProvider extends ServerProvider {
  final String? ipAddress;
  final OnServeCallback? onServe;

  const ShelfServerProvider({
    required super.port,
    this.ipAddress,
    this.onServe,
  });

  /// Initializes the server and starts listening for incoming requests.
  @override
  Future<void> init(handler) async {
    final server = await shelf_io.serve(
      _handler(handler),
      InternetAddress.tryParse(ipAddress ?? '127.0.0.1')!,
      port,
    );

    onServe?.call(server);
  }

  /// Constructs a Shelf handler to process incoming requests.
  Handler _handler(HandlerCallback callback) {
    return (Request request) async {
      final body = await _body(request);
      final ctx = RequestContext(
        httpMethod: request.method,
        uri: request.url,
        queries: request.url.queryParameters,
        headers: request.headers,
        body: body,
      );

      final res = (await callback(ctx));

      return Response(
        res.statusCode,
        body: res.body,
        headers: res.headers,
      );
    };
  }

  /// Reads and retrieves the body of the incoming request.
  Future<Uint8List> _body(Request request) async {
    final bytes = await request.read().fold<List<int>>(
      <int>[],
      (previous, element) => previous..addAll(element),
    );

    return Uint8List.fromList(bytes);
  }
}
