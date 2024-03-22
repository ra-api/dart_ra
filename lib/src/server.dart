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
  final String baseEndpoint;

  const Server({
    required this.currentApiVersion,
    required this.packages,
    required this.provider,
    this.poweredBy,
    this.verbose = false,
    this.baseEndpoint = 'api',
  });

  Future<void> serve() async => await provider.init(_methodHandler);

  Future<MethodResponse> _methodHandler(RequestContext ctx) async {
    final handler = ApiHandler(
      currentApiVersion: currentApiVersion,
      packages: packages,
      verbose: verbose,
    );

    return handler.handle(
      ctx: ctx,
      baseEndpoint: baseEndpoint,
    );
  }
}
