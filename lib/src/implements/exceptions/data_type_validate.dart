part of 'exceptions.dart';

final class DataTypeValidateException extends ApiException {
  final DataType dataType;
  const DataTypeValidateException({
    required this.dataType,
  }) : super(statusCode: 400);

  @override
  String get reason {
    return 'Validation error';
  }

  @override
  JsonType? get verboseFields {
    return {
      'dataType': dataType.runtimeType.toString(),
      'summary': dataType.summary,
    };
  }
}
