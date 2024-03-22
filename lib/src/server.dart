import 'dart:async';

import 'package:mab/src/handler.dart';
import 'package:mab/src/method_response.dart';
import 'package:mab/src/package.dart';
import 'package:mab/src/plugin/plugin.dart';
import 'package:mab/src/request_context.dart';
import 'package:mab/src/server_provider.dart';
import 'package:meta/meta.dart';

@immutable
final class Server {
  final List<Package> packages;
  final String? poweredBy;
  final double currentApiVersion;
  final bool verbose;
  final ServerProvider provider;
  final String baseEndpoint;
  final List<Plugin> plugins;

  const Server({
    required this.currentApiVersion,
    required this.packages,
    required this.provider,
    this.plugins = const [],
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
      plugins: plugins,
    );

    return handler.handle(
      ctx: ctx,
      baseEndpoint: baseEndpoint,
    );
  }
}
