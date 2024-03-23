import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:mab/src/core/request_context.dart';
import 'package:mab/src/core/server_provider.dart';
import 'package:meta/meta.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

typedef OnServeCallback = void Function(HttpServer);

@immutable
final class ShelfServerProvider extends ServerProvider {
  final OnServeCallback? onServe;

  const ShelfServerProvider({required super.port, this.onServe});

  @override
  Future<void> init(handler) async {
    final server = await shelf_io.serve(
      Pipeline().addHandler(_handler(handler)),
      'localhost',
      port,
    );

    onServe?.call(server);
  }

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

      final res = (await callback(ctx)).build();

      return Response(
        res.statusCode,
        body: res.body,
        headers: res.headers,
      );
    };
  }

  Future<Uint8List> _body(Request request) async {
    final bytes = await request.read().fold<List<int>>(
      <int>[],
      (previous, element) => previous..addAll(element),
    );

    return Uint8List.fromList(bytes);
  }
}
