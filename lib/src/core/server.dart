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

/// Represents a server instance that serves HTTP requests.
@immutable
class Server {
  final List<Package> packages;
  final String? poweredBy;
  final double currentApiVersion;
  final bool verbose;
  final ServerProvider provider;
  final String baseEndpoint;
  final List<Plugin> plugins;

  /// Constructs a [Server] instance with the specified parameters.
  ///
  /// [currentApiVersion] is the current version of the API.
  /// [packages] is a list of packages served by the server.
  /// [provider] is the server provider.
  /// [plugins] is a list of plugins to be used.
  /// [poweredBy] is an optional string representing the server name or framework.
  /// [verbose] determines whether the server logs verbose output.
  /// [baseEndpoint] is the base endpoint of the server's API.
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

  /// Starts serving HTTP requests.
  Future<void> serve() async {
    handler = ApiHandler(
      currentApiVersion: currentApiVersion,
      packages: packages,
      verbose: verbose,
      plugins: plugins,
    );
    PluginProviderSingleton.instance().init(
      plugins
          .whereType<PluginProvider>()
          .map((e) => PluginData(plugin: e, scope: PluginScope.global))
          .toList(growable: false),
    );
    await provider.init(_methodHandler);
  }

  /// Handles incoming HTTP requests.
  Future<ResponseContext> _methodHandler(RequestContext ctx) async {
    return handler.handle(
      ctx: ctx,
      baseEndpoint: baseEndpoint,
    );
  }
}
