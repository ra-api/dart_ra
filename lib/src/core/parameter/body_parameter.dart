import 'dart:typed_data';

import 'package:ra/src/core/parameter/parameter.dart';
import 'package:ra/src/types.dart';

/// Represents a body parameter for a method.
base class BodyParameter<O> extends Parameter<Uint8List, O> {
  /// Constructs a [BodyParameter] with the specified parameters.
  ///
  /// [dataType] is the data type of the parameter.
  /// [optional] indicates whether the parameter is optional.
  /// [summary] is a summary of the parameter.
  BodyParameter({
    required super.dataType,
    super.optional,
    super.summary,
    super.lazy,
  }) : super(source: DataSource.body, id: 'body');
}
