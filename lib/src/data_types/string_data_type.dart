part of 'data_types.dart';

class StringDataType extends DataType<String, String> {
  final RegExp? pattern;
  final bool trim;
  const StringDataType({this.pattern, this.trim = false});

  @override
  FutureOr<String> convert(String data) {
    final newData = trim ? data.trim() : data;

    if (pattern == null) {
      return newData;
    }

    if (!pattern!.hasMatch(newData)) {
      throw DataTypeValidateException(dataType: this);
    }

    return newData;
  }

  @override
  String get summary {
    const message = 'Convert value to string';

    if (pattern != null) {
      return '$message with pattern ${pattern!.pattern}';
    }

    return message;
  }
}
