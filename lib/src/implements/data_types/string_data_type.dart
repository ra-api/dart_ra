part of 'data_types.dart';

@immutable
class StringDataType extends DataType<String, String> {
  final RegExp? pattern;
  final bool trim;
  const StringDataType({this.pattern, this.trim = false, super.initial});

  @override
  FutureOr<String> convert(String data, DataTypeContext ctx) {
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
