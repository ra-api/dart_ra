library;

export 'plugin_events.dart';

abstract class Plugin {
  const Plugin();
}

// final class RateLimiter extends Plugin
//     implements EventBeforeRequest, EventErrorHandle {
//   const RateLimiter();
//
//   @override
//   void onBeforeRequest(MethodContext ctx) {
//     throw UnimplementedError();
//   }
//
//   @override
//   void onErrorHandle(ApiException exception) {
//     throw UnimplementedError();
//   }
// }
