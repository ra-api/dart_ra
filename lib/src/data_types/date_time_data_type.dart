part of 'data_types.dart';

class DateTimeDataType extends DataType<String, DateTime> {
  const DateTimeDataType({super.initial});

  @override
  FutureOr<DateTime> convert(String data) {
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
