import 'package:mab/mab.dart';

final class CartSaveMethodLegacy extends Method<JsonContentType, String> {
  const CartSaveMethodLegacy();

  @override
  String get name => 'save';

  @override
  double get version => 1;

  @override
  Future<MethodResponse<JsonContentType, String>> handle(ctx) async {
    return response..body('Cart save legacy method');
  }

  @override
  ResponseContentType<String> get contentType => JsonContentType();
}
