import 'package:mab/mab.dart';
import 'package:mab/src/method_decl.dart';

import '../../registry.dart';

final class SpecMethod extends Method<JsonContentType, Object> {
  final List<RegistryItem> decls;

  SpecMethod({required this.decls});

  @override
  Future<MethodResponse<JsonContentType, Object>> handle(ctx) async {
    final res = decls.map(MethodDecl.new).map((e) => e.export()).toList();

    return response..body(res);
  }

  @override
  String get name => 'spec';

  @override
  ResponseContentType<Object> get contentType {
    return JsonContentType();
  }
}
