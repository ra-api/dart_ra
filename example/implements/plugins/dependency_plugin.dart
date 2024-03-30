import 'dart:async';

import 'package:mab/mab.dart';
import 'package:mab/src/core/response_context.dart';

final class DependencyOptions extends PluginOptions {
  final String foo = 'bar';
}

final class DependencyPlugin extends PluginProvider<DependencyOptions>
    implements ErrorHandleHook {
  DependencyPlugin({required super.options});

  @override
  void onErrorHandle(event) {
    print(event.exception.reported);
    print(event.exception.reason);
    print(event.exception.statusCode);
  }
}

final class DependencyConsumerPlugin extends PluginConsumer<DependencyOptions>
    implements MethodResponseHook {
  @override
  FutureOr<ResponseCtx> onMethodResponse(MethodResponseEvent event) {
    print(event.request.uri);
    final headers = event.response.headers;

    return event.response.copyWith(
      headers: headers..putIfAbsent('foo', () => 'bar'),
    );
  }
}
