import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ra/ra.dart';
import 'package:token_bucket/token_bucket.dart';

/// Options for configuring rate limiting.
@immutable
final class RateLimitOptions extends PluginOptions {
  final BucketStorage storage;

  /// Constructs [RateLimitOptions] with the specified [storage].
  const RateLimitOptions({required this.storage});
}

/// Provider for rate limiting functionality.
@immutable
final class RateLimitProvider extends PluginProvider<RateLimitOptions> {
  /// Constructs [RateLimitProvider] with the specified [options].
  const RateLimitProvider({required super.options});
}

/// Callback signature for generating bucket IDs.
typedef BucketIdCallback = String Function(RequestContext ctx);

/// Consumer for rate limiting functionality.
@immutable
final class RateLimitConsumer extends PluginConsumer<RateLimitOptions>
    implements MethodRequestHook {
  final int capacity;
  final RefillFrequency frequency;
  final int coast;
  final BucketIdCallback bucketId;

  /// Constructs [RateLimitConsumer] with the specified parameters.
  ///
  /// [capacity] is the maximum tokens the bucket can hold.
  /// [frequency] is the rate at which tokens are refilled.
  /// [bucketId] is the callback function to generate bucket IDs.
  /// [coast] is the number of tokens consumed per request.
  const RateLimitConsumer({
    required this.capacity,
    required this.frequency,
    required this.bucketId,
    this.coast = 1,
  });

  @override
  FutureOr<RequestContext> onMethodRequest(MethodRequestEvent event) async {
    final bucket = TokenBucket(
      capacity: capacity,
      storage: options.storage,
      frequency: frequency,
    );

    final state = await bucket.consume(
      bucketId: bucketId(event.request),
      coast: coast,
    );
    if (!state.consumed) {
      throw ManyRequestException(remainToRefill: state.remainToRefill);
    }

    return event.request;
  }
}

/// Exception thrown when too many requests are made.
@immutable
final class ManyRequestException extends ApiException {
  final int remainToRefill;

  /// Constructs a [ManyRequestException] with the remaining time until
  /// the rate limit is reset.
  ///
  /// [remainToRefill] is the remaining time in milliseconds.
  const ManyRequestException({
    required this.remainToRefill,
  }) : super(statusCode: 429, reported: false);

  @override
  String get reason => 'Many requests';

  @override
  Map<String, String> get headers {
    return {
      'x-remain-to-refill-ms': remainToRefill.toString(),
    };
  }

  @override
  JsonType? get verboseFields {
    return {'remainToRefill': '$remainToRefill ms'};
  }
}
