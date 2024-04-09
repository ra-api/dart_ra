import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ra/src/core/handler.dart';
import 'package:ra/src/core/plugin/plugin.dart';
import 'package:ra/src/core/plugin/plugin_provider_singleton.dart';
import 'package:ra/src/core/request_context.dart';
import 'package:ra/src/core/response_context.dart';
import 'package:ra/src/core/server_provider.dart';
import 'package:ra/src/package.dart';
import 'package:ra/src/types.dart';

@immutable
final class Server {
  final List<Package> packages;
  final String? poweredBy;
  final double currentApiVersion;
  final bool verbose;
  final ServerProvider provider;
  final String baseEndpoint;
  final List<Plugin> plugins;

  Server({
    required this.currentApiVersion,
    required this.packages,
    required this.provider,
    this.plugins = const [],
    this.poweredBy,
    this.verbose = false,
    this.baseEndpoint = 'api',
  });

  late final ApiHandler handler;

  Future<void> serve() async {
    handler = ApiHandler(
      currentApiVersion: currentApiVersion,
      packages: packages,
      verbose: verbose,
      plugins: plugins,
    );
    // Register global plugin providers
    PluginProviderSingleton.instance().init(
      plugins
          .whereType<PluginProvider>()
          .map((e) => PluginData(plugin: e, scope: PluginScope.global))
          .toList(growable: false),
    );
    await provider.init(_methodHandler);
  }

  Future<ResponseCtx> _methodHandler(RequestCtx ctx) async {
    return handler.handle(
      ctx: ctx,
      baseEndpoint: baseEndpoint,
    );
  }
}
