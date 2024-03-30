part of 'hooks.dart';

/// Method response event
@immutable
final class MethodResponseEvent {
  final RequestCtx request;
  final ResponseCtx response;

  const MethodResponseEvent({
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
