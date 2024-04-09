import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ra/src/core/request_context.dart';
import 'package:ra/src/core/response_context.dart';

typedef HandlerCallback = Future<ResponseCtx> Function(RequestCtx ctx);

@immutable
abstract base class ServerProvider {
  final int port;

  const ServerProvider({required this.port});

  @mustCallSuper
  Future<void> init(HandlerCallback handler);
}
