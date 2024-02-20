import 'package:mab/mab.dart';
import 'package:mab/src/method_decl.dart';
import 'package:meta/meta.dart';

import 'registry.dart';

/// Класс отвечающий за инициализацию [Registry], и дальнейший поиск метода
/// по пакету, имени и версии
@immutable
final class ApiHandler {
  /// Текущая актуальная версия, если в методе не указана версия,
  /// то ему будет присвоена [currentApiVersion]
  final double currentApiVersion;

  /// Пакеты с которыми запускается сервер
  final List<Package> packages;

  /// Реестр методов, представление дерева в список
  late final Registry _registry = Registry(
    packages: packages,
    currentApiVersion: currentApiVersion,
  );

  ApiHandler({
    required this.currentApiVersion,
    required this.packages,
  });

  /// Метод отвечает за поиск метода из реестра, подготовки и проверки
  /// параметров для его выполнения и получения [MethodResponse] на выходе
  Future<MethodResponse> handle({
    required String package,
    required String method,
    required double version,
    required Map<String, String> queries,
    required Map<String, String> headers,
    required Stream<List<int>> body,
  }) async {
    final handler = _registry.find(
      package: package,
      method: method,
      version: version,
    );

    if (handler == null) {
      final versions = _registry.availableVersions(
        package: package,
        method: method,
      );

      if (versions.isEmpty) {
        return MethodResponse<JsonContentType, String>(JsonContentType())
          ..statusCode(404)
          ..body('method not found');
      } else {
        return MethodResponse<JsonContentType, String>(JsonContentType())
          ..statusCode(400)
          ..body('wrong method version $version, available versions $versions');
      }
    }

    final ctx = await _methodContext(
      handler: handler,
      queries: queries,
      headers: queries,
      body: body,
    );

    return handler.method.handle(ctx);
  }

  Future<MethodContext> _methodContext({
    required RegistryItem handler,
    required Map<String, String> queries,
    required Map<String, String> headers,
    required Stream<List<int>> body,
  }) async {
    final ctx = <String, Object>{};

    for (final param in handler.method.params) {
      var raw = switch (param.source) {
        MethodDataSource.query => queries[param.id],
        MethodDataSource.header => headers[param.id],
        MethodDataSource.body => await body.toList(),
      };

      final val = (raw == null && !param.isRequired)
          ? param.initial
          : await param.dataType.convert(raw);

      ctx.putIfAbsent(param.id, () => val);
    }

    final methods =
        _registry.methods.map(MethodDecl.new).toList(growable: false);

    return MethodContext(
      ctx,
      methods: methods,
      current: MethodDecl(handler),
    );
  }
}
