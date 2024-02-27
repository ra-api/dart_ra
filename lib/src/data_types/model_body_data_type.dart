part of 'data_types.dart';

typedef TransformCallback<T> = T Function(JsonType value);

/// DataType который позволяет преобразовать body в заданную модель
final class ModelBodyDataType<T> extends DataType<Uint8List, T> {
  final TransformCallback<T> onTransform;

  const ModelBodyDataType({required this.onTransform});

  @override
  FutureOr<T> convert(Uint8List data) {
    final json = jsonDecode(utf8.decode(data));
    return onTransform(json);
  }

  @override
  String get summary => 'Transform bytes to Model';
}
