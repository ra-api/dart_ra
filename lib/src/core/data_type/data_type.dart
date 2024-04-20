import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ra/src/core/data_type/data_type_context.dart';

/// Interface for implementing data extraction, conversion, and validation.
@immutable
abstract class DataType<I, O> {
  /// Default value if not explicitly set.
  final O? initial;

  /// Constructs a [DataType] with the specified initial value.
  const DataType({this.initial});

  /// A brief description of the DataType and its functions.
  String get summary;

  /// Converts data from type I to type O.
  FutureOr<O> convert(I data, DataTypeContext ctx);
}
