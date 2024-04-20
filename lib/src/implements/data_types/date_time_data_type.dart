part of 'data_types.dart';

@immutable
class DateTimeDataType extends DataType<String, DateTime> {
  const DateTimeDataType({super.initial});

  @override
  FutureOr<DateTime> convert(String data, DataTypeContext ctx) {
    try {
      return DateTime.parse(data);
    } on Object {
      throw DataTypeValidateException(dataType: this);
    }
  }

  @override
  String get summary {
    return 'Convert string to date time object, string must be '
        'format yyyy-mm-dd';
  }
}
