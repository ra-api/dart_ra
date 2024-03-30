part of 'hooks.dart';

/// Error handle event
final class MethodResponseEvent {
  final RequestCtx request;
  final ResponseCtx response;

  MethodResponseEvent({
    required this.request,
    required this.response,
  });
}

@immutable
abstract interface class MethodResponseHook extends PluginHook {
  const MethodResponseHook();

  @internal
  FutureOr<ResponseCtx> onMethodResponse(MethodResponseEvent event);
}
