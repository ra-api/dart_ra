import 'dart:async';

import 'package:ra/ra.dart';

final class DependencyOptions extends PluginOptions {
  final String foo = 'bar';
}

final class DependencyPlugin extends PluginProvider<DependencyOptions>
    implements ErrorHandleHook, ServerRequestHook {
  const DependencyPlugin({required super.options});

  @override
  void onErrorHandle(event) {
    print(event.exception.reported);
    print(event.exception.reason);
    print(event.exception.statusCode);
  }

  @override
  FutureOr<ServerRequest> onServerRequest(ServerRequestEvent event) {
    print('${event.request.httpMethod}: ${event.request.uri}');
    return event.request;
  }
}

final class DependencyConsumerPlugin extends PluginConsumer<DependencyOptions>
    implements ServerResponseHook, ErrorHandleHook {
  @override
  FutureOr<ServerResponse> onServerResponse(ServerResponseEvent event) {
    final headers = event.response.headers;

    return event.response.copyWith(
      headers: headers..putIfAbsent('foo', () => 'bar'),
    );
  }

  @override
  void onErrorHandle(event) {
    print(event.exception.reported);
    print(event.exception.reason);
    print(event.exception.statusCode);
  }
}
