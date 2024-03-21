part of 'methods.dart';

final class PostmanCollectionMethod extends Method<JsonType> {
  final String methodName;
  final String collectionName;
  final Uri host;
  final Map<String, String?>? variables;

  PostmanCollectionMethod({
    required this.collectionName,
    required this.host,
    this.methodName = 'postmanCollection',
    this.variables,
  });
  @override
  ResponseContentType<JsonType> get contentType => JsonContentType();

  @override
  Future<MethodResponse<JsonType>> handle(MethodContext ctx) async {
    return response
      ..body({
        'info': _info(),
        'item': ctx.methods.map(_declToItem).toList(),
        'variable': _variables(),
      });
  }

  JsonType _info() {
    return {
      'name': collectionName,
      'schema':
          'https://schema.getpostman.com/json/collection/v2.1.0/collection.json',
    };
  }

  List<JsonType> _variables() {
    final List<JsonType> other = (variables?.keys ?? [])
        .map((e) {
          return {
            'id': e,
            'value': variables?[e],
          };
        })
        .cast<JsonType>()
        .toList(growable: false);
    return <JsonType>[
      {'key': 'host', 'value': host.toString(), 'type': 'string'},
      ...other,
    ];
  }

  List<JsonType> _declToHeaders(MethodDecl decl) {
    return decl.parameters.where((element) {
      return element.dataSource == DataSource.header;
    }).map((e) {
      final value =
          variables?.containsKey(e.id) == true ? '{{${e.id}}' : ':${e.id}';
      return {
        'key': e.id,
        'value': value,
        'description': e.summary,
      };
    }).toList(growable: false);
  }

  JsonType _declToItem(MethodDecl decl) {
    final item = {
      'name': decl.name,
      'request': {
        'method': decl.httpMethod,
        'description': decl.summary,
        'url': _declToUrl(decl),
        'header': _declToHeaders(decl),
      }
    };

    return item;
  }

  JsonType _declToUrl(MethodDecl decl) {
    return {
      'raw': '{{host}}/${decl.package}.${decl.name}',
      'host': ['{{host}}'],
      'path': '${decl.package}.${decl.name}',
      'query': decl.parameters.where((e) {
        return e.dataSource == DataSource.query;
      }).map((e) {
        final value = variables?.containsKey(e.id) == true ? '{{${e.id}}}' : '';
        return {'key': e.id, 'value': value, 'description': e.summary};
      }).toList(growable: false),
    };
  }

  @override
  String get name => methodName;
}
