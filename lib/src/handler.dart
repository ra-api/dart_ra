import 'dart:typed_data';

import 'package:mab/mab.dart';
import 'package:mab/src/data_source_context.dart';
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
  final bool verbose;

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
    required this.verbose,
  });

  /// Метод отвечает за поиск метода из реестра, подготовки и проверки
  /// параметров для его выполнения и получения [MethodResponse] на выходе
  Future<MethodResponse> handle({
    required String package,
    required String method,
    required double version,
    required Map<String, String> queries,
    required Map<String, String> headers,
    required Uint8List body,
  }) async {
    try {
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
          throw MethodNotFoundException();
        } else {
          throw WrongMethodVersionException(
            invalidVersion: version,
            availableVersions: versions,
          );
        }
      }

      final ctx = await _methodContext(
        handler: handler,
        queries: queries,
        headers: queries,
        body: body,
      );
      return (await handler.method.handle(ctx))..decl(MethodDecl(handler));
    } on ApiException catch (error) {
      final body = {
        'error': {
          'message': error.reason,
          ...error.extraFields ?? {},
          if (verbose) ...{'verbose': error.verboseFields},
        },
      };
      return MethodResponse<JsonContentType, JsonType>(JsonContentType())
        ..statusCode(error.statusCode)
        ..body(body);
    }
  }

  Future<MethodContext> _methodContext({
    required RegistryItem handler,
    required Map<String, String> queries,
    required Map<String, String> headers,
    required Uint8List body,
  }) async {
    final ctx = <String, dynamic>{};

    final dataSourceCtx = DataSourceContext(
      headers: headers,
      queries: queries,
      body: body,
    );

    for (final param in handler.params) {
      final raw = await param.extract(dataSourceCtx);

      try {
        final val = (raw == null && !param.isRequired)
            ? param.initial
            : await param.dataType.convert(raw);

        ctx.putIfAbsent(param.id, () => val);
      } on ApiException {
        rethrow;
      } on Object catch (e, st) {
        throw Error.throwWithStackTrace(
          DataTypeException(parameter: param),
          st,
        );
      }
    }

    final methods =
        _registry.methods.map(MethodDecl.new).toList(growable: false);

    return MethodContext(
      ctx,
      methods: methods,
      current: MethodDecl(handler),
      verbose: verbose,
    );
  }
}
