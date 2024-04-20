import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:ra/src/core/method/method_decl.dart';

/// Interface for implementing conversion of type T to binary form.
@immutable
abstract class ResponseContentType<T extends Object> {
  /// Since working with bytes is the simplest, we convert our T to bytes.
  Uint8List apply(T data, MethodDecl? decl);

  /// This string will be added to the server response header as the content-type.
  String get mimeType;

  const ResponseContentType();
}
