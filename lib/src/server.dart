import 'dart:async';
import 'dart:io';

import 'package:mab/mab.dart';
import 'package:meta/meta.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import 'handler.dart';

/// Класс который реализует server на основе shelf
@immutable
final class Server {
  final int port;
  final List<Package> packages;
  final String? poweredBy;
  final double currentApiVersion;

  const Server({
    required this.currentApiVersion,
    required this.packages,
    this.port = 80,
    this.poweredBy,
  });

  Future<HttpServer> create() async {
    final server = await shelf_io.serve(
      _handler,
      'localhost',
      port,
      poweredByHeader: poweredBy,
    );

    print('🚀Serving at http://${server.address.host}:${server.port}');

    return server;
  }

  FutureOr<Response> _handler(Request request) async {
    final url = request.url;
    if (!url.path.contains('api/')) {
      return Response.badRequest();
    }

    final handler = ApiHandler(
      currentApiVersion: currentApiVersion,
      packages: packages,
    );
    final path = url.path.substring(4).split('.');
    final method = path.removeLast();
    final package = path.join('.');

    final res = await handler.handle(
      package: package,
      method: method,
      version: _version(request),
      queries: _queries(request),
      headers: request.headers,
      body: request.read(),
    );

    return res.build();
  }

  Map<String, String> _queries(Request request) {
    final queries = Map.of(request.url.queryParameters);
    queries['v'] = _version(request).toString();

    return queries;
  }

  double _version(Request request) {
    final queryVersion = request.url.queryParameters['v'];
    if (queryVersion == null) {
      return currentApiVersion;
    }

    return double.tryParse(queryVersion) ?? currentApiVersion;
  }
}
