part of 'data_types.dart';

@immutable
final class AnyOfDataType<I, O> extends DataType<I, O> {
  final List<I> input;
  final DataType<I, O> _dataType;

  const AnyOfDataType(
    this._dataType, {
    super.initial,
    required this.input,
  });

  @override
  FutureOr<O> convert(I data, DataTypeCtx ctx) {
    if (!input.contains(data)) {
      throw DataTypeValidateException(dataType: this);
    }

    return _dataType.convert(data, ctx);
  }

  @override
  String get summary => 'One of any input items, input: $input';
}
