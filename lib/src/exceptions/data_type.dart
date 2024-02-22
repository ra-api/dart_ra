part of 'exceptions.dart';

final class DataTypeException extends ApiException {
  final Parameter parameter;

  const DataTypeException({
    required this.parameter,
  }) : super(statusCode: 400);

  @override
  String get reason {
    return 'param ${parameter.id} value is wrong';
  }

  @override
  JsonType? extraFields(bool verbose) {
    if (!verbose) return null;

    final fields = {
      'required': parameter.isRequired,
      'summary': parameter.summary,
    };

    if (parameter is MethodParameter) {
      final methodParam = parameter as MethodParameter;
      fields.putIfAbsent('source', () => methodParam.source.name);
      fields.putIfAbsent('dataType', () => methodParam.dataType.summary);
    }

    return {'param': fields};
  }
}
