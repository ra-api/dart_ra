import 'dart:async';

import 'package:mab/mab.dart';
import 'package:mab/src/request_context.dart';
import 'package:meta/meta.dart';

import 'handler.dart';
import 'server_provider.dart';

@immutable
final class Server {
  final List<Package> packages;
  final String? poweredBy;
  final double currentApiVersion;
  final bool verbose;
  final ServerProvider provider;

  const Server({
    required this.currentApiVersion,
    required this.packages,
    required this.provider,
    this.poweredBy,
    this.verbose = false,
  });

  Future<void> serve() async => await provider.init(_methodHandler);

  Future<MethodResponse> _methodHandler(RequestContext ctx) async {
    final url = ctx.uri;

    final path = url.path.substring(4).split('.');
    final method = path.removeLast();
    final package = path.join('.');

    final handler = ApiHandler(
      currentApiVersion: currentApiVersion,
      packages: packages,
      verbose: verbose,
    );

    return handler.handle(
      package: package,
      method: method,
      version: _versionNew(ctx),
      queries: _queriesNew(ctx),
      headers: ctx.headers,
      body: ctx.body,
      httpMethod: ctx.httpMethod,
    );
  }

  Map<String, String> _queriesNew(RequestContext ctx) {
    final queries = Map.of(ctx.uri.queryParameters);
    queries['v'] = _versionNew(ctx).toString();

    return queries;
  }

  double _versionNew(RequestContext ctx) {
    final queryVersion = ctx.uri.queryParameters['v'];
    if (queryVersion == null) {
      return currentApiVersion;
    }

    return double.tryParse(queryVersion) ?? currentApiVersion;
  }
}
