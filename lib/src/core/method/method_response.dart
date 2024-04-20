import 'package:meta/meta.dart';
import 'package:ra/src/core/content_type.dart';
import 'package:ra/src/core/method/method_decl.dart';
import 'package:ra/src/core/response_context.dart';

/// Enum representing keys for the method response data.
enum _Key {
  statusCode,
  headers,
  body,
  decl,
}

/// Represents a method response.
@immutable
class MethodResponse<T extends Object> {
  final ResponseContentType<T> _contentType;

  /// The data associated with the method response.
  final _data = <_Key, Object>{
    _Key.statusCode: 200,
    _Key.headers: <String, String>{},
  };

  /// Constructs a [MethodResponse] with the specified content type.
  MethodResponse(this._contentType);

  /// Sets the status code of the method response.
  void statusCode(int code) {
    _data[_Key.statusCode] = code;
  }

  /// Adds a header to the method response.
  void header({required String name, required String value}) {
    (_data[_Key.headers] as Map).putIfAbsent(name, () => value);
  }

  /// Adds multiple headers to the method response.
  void headers(Map<String, String> headers) {
    (_data[_Key.headers] as Map).addAll(headers);
  }

  /// Sets the body of the method response.
  void body(T value) {
    _data[_Key.body] = value;
  }

  /// Sets the method declaration associated with the method response.
  void decl(MethodDecl value) {
    _data[_Key.decl] = value;
  }

  /// Builds the method response into a [ResponseContext].
  ResponseContext build() {
    final statusCode = _data[_Key.statusCode] as int;
    final body = _data[_Key.body] as T;
    final headers = _data[_Key.headers] as Map<String, String>;
    final decl = _data[_Key.decl] as MethodDecl?;

    // Set content-type header
    headers['content-type'] = _contentType.mimeType;

    return ResponseContext(
      statusCode: statusCode,
      body: _contentType.apply(body, decl),
      headers: headers,
    );
  }
}
