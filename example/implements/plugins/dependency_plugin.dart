import 'dart:async';

import 'package:ra_core/mab.dart';
import 'package:ra_core/src/core/request_context.dart';
import 'package:ra_core/src/core/response_context.dart';

final class DependencyOptions extends PluginOptions {
  final String foo = 'bar';
}

final class DependencyPlugin extends PluginProvider<DependencyOptions>
    implements ErrorHandleHook, MethodRequestHook {
  const DependencyPlugin({required super.options});

  @override
  void onErrorHandle(event) {
    print(event.exception.reported);
    print(event.exception.reason);
    print(event.exception.statusCode);
  }

  @override
  FutureOr<RequestCtx> onMethodRequest(MethodRequestEvent event) {
    print('${event.request.httpMethod}: ${event.request.uri}');
    return event.request;
  }
}

final class DependencyConsumerPlugin extends PluginConsumer<DependencyOptions>
    implements MethodResponseHook {
  @override
  FutureOr<ResponseCtx> onMethodResponse(MethodResponseEvent event) {
    final headers = event.response.headers;

    return event.response.copyWith(
      headers: headers..putIfAbsent('foo', () => 'bar'),
    );
  }
}
