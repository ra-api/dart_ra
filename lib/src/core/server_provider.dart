import 'dart:async';

import 'package:ra_core/src/core/request_context.dart';
import 'package:ra_core/src/core/response_context.dart';
import 'package:meta/meta.dart';

typedef HandlerCallback = Future<ResponseCtx> Function(RequestCtx ctx);

@immutable
abstract base class ServerProvider {
  final int port;

  const ServerProvider({required this.port});

  @mustCallSuper
  Future<void> init(HandlerCallback handler);
}
