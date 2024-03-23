part of 'data_types.dart';

@immutable
class StringDataType extends DataType<String, String> {
  final RegExp? pattern;
  final bool trim;
  const StringDataType({this.pattern, this.trim = false, super.initial});

  @override
  FutureOr<String> convert(DataTypeContext<String> ctx) {
    final newData = trim ? ctx.data.trim() : ctx.data;

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
