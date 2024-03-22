import 'package:mab/src/exceptions/exceptions.dart';

abstract interface class EventErrorHandle {
  void onErrorHandle(ApiException exception);
}
