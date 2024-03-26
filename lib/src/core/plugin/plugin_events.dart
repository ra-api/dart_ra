import 'package:mab/src/implements/exceptions/exceptions.dart';
import 'package:meta/meta.dart';

abstract interface class EventErrorHandle {
  @internal
  void onErrorHandle(ApiException exception);
}
