part of 'data_types.dart';

typedef TransformCallback<T> = T Function(JsonType value);

/// DataType который позволяет преобразовать body в заданную модель
@immutable
final class ModelBodyDataType<T> extends DataType<Uint8List, T> {
  final TransformCallback<T> onTransform;

  const ModelBodyDataType({required this.onTransform, super.initial});

  @override
  FutureOr<T> convert(DataTypeContext<Uint8List> ctx) {
    try {
      final json = jsonDecode(utf8.decode(ctx.data));
      return onTransform(json);
    } on Object {
      throw DataTypeValidateException(dataType: this);
    }
  }

  @override
  String get summary => 'Transform bytes to Model';
}
