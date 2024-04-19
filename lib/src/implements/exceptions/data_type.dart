part of 'exceptions.dart';

final class DataTypeException extends ApiException {
  final Parameter parameter;

  const DataTypeException({
    required this.parameter,
  }) : super(statusCode: 400);

  @override
  String get reason {
    return 'Param "${parameter.id}" value is wrong';
  }

  @override
  JsonType? get verboseFields {
    final fields = {
      'required': parameter.isRequired,
      'summary': parameter.summary,
      'source': parameter.source.name
    };

    return fields;
  }
}
