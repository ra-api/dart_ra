import 'package:mab/mab.dart';

import '../../../implements/json_method.dart';

final class CartSaveMethodLegacy extends JsonMethod {
  CartSaveMethodLegacy();

  @override
  String get name => 'save';

  @override
  double get version => 1;

  @override
  Future<MethodJsonResponse> handle(ctx) async {
    return response..body(Foo());
  }
}

final class Foo implements JsonResponse {
  @override
  JsonType export() {
    return {'message': 'Cart save legacy method'};
  }
}
