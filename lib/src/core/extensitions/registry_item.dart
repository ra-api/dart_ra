part of 'extensions.dart';

extension RegistryItemExt on RegistryItem {
  Future<MethodContext> buildContext({
    required ServerRequest request,
    required List<RegistryItem> methods,
    required bool verbose,
  }) async {
    final dataSourceCtx = DataSourceContext(
      headers: request.headers,
      queries: request.queries,
      body: request.body,
    );

    return MethodContext(
      await _valueContext(dataSourceContext: dataSourceCtx),
      dataSourceContext: dataSourceCtx,
      pluginRegistry: pluginRegistry,
      current: MethodDecl(this),
      methods: methods.map(MethodDecl.new).toList(growable: false),
      verbose: verbose,
    );
  }

  Future<Map<String, dynamic>> _valueContext({
    required DataSourceContext dataSourceContext,
  }) async {
    final valueCtx = <String, dynamic>{};
    final dataTypeCtx = DataTypeContext(pluginRegistry: pluginRegistry);

    for (final paramData in paramsData) {
      final parameter = paramData.parameter;
      final dataType = parameter.dataType;
      final raw = parameter.extract(dataSourceContext);

      if (parameter.isRequired) {
        if (raw == null || !dataType.validate(raw)) {
          throw DataTypeValidateException(dataType: dataType);
        }
      }

      // parameter lazy or optional and datatype not initial
      if (parameter.lazy) {
        continue;
      }

      try {
        final val = (raw == null && parameter.optional)
            ? parameter.dataType.initial
            : await parameter.dataType.convert(raw, dataTypeCtx);
        valueCtx.putIfAbsent(parameter.id, () => val);
      } on ApiException {
        rethrow;
      } on Object catch (e, st) {
        throw Error.throwWithStackTrace(
          DataTypeException(parameter: parameter),
          st,
        );
      }
    }

    return valueCtx;
  }
}
