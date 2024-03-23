part of 'data_types.dart';

typedef EnumMapCallback<T extends Enum> = Function(String value);

final class EnumDataType<T extends Enum> extends DataType<String, T> {
  final EnumMapCallback onMap;

  const EnumDataType({
    super.initial,
    required this.onMap,
  });
  @override
  FutureOr<T> convert(DataTypeContext<String> ctx) {
    try {
      return onMap(ctx.data);
    } on Object {
      throw DataTypeValidateException(dataType: this);
    }
  }

  @override
  String get summary => 'Map string value to enum $T';
}
