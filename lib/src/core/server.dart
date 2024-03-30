import 'dart:async';

import 'package:mab/src/core/handler.dart';
import 'package:mab/src/core/plugin/plugin.dart';
import 'package:mab/src/core/plugin/plugin_provider_singleton.dart';
import 'package:mab/src/core/request_context.dart';
import 'package:mab/src/core/response_context.dart';
import 'package:mab/src/core/server_provider.dart';
import 'package:mab/src/package.dart';
import 'package:mab/src/types.dart';
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
