import 'package:mab/mab.dart';
import 'package:mab/src/response_context.dart';
import 'package:meta/meta.dart';

enum _Key {
  statusCode,
  headers,
  body,
  decl,
}

/// Это будет переделано
@immutable
class MethodResponse<T extends Object> {
  final ResponseContentType<T> _contentType;

  MethodResponse(this._contentType);

  final _data = <_Key, Object>{
    _Key.statusCode: 200,
    _Key.headers: <String, String>{},
  };

  void statusCode(int code) {
    _data[_Key.statusCode] = code;
  }

  void header({required String name, required String value}) {
    (_data[_Key.headers] as Map).putIfAbsent(name, () => value);
  }

  void body(T value) {
    _data[_Key.body] = value;
  }

  void decl(MethodDecl value) {
    _data[_Key.decl] = value;
  }

  ResponseContext build() {
    final statusCode = _data[_Key.statusCode] as int;
    final body = _data[_Key.body] as T;
    final headers = _data[_Key.headers] as Map<String, String>;
    final decl = _data[_Key.decl] as MethodDecl?;

    headers['content-type'] = _contentType.mimeType;

    return ResponseContext(
      statusCode: statusCode,
      body: _contentType.apply(body, decl),
      headers: headers,
    );
  }
}
