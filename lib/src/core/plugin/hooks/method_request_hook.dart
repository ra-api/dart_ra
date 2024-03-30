part of 'hooks.dart';

/// Method request event
@immutable
final class MethodRequestEvent {
  final RequestCtx request;

  const MethodRequestEvent({
    required this.request,
  });
}

@immutable
abstract interface class MethodRequestHook extends PluginHook {
  const MethodRequestHook();

  @internal
  FutureOr<RequestCtx> onMethodRequest(MethodRequestEvent event);
}
