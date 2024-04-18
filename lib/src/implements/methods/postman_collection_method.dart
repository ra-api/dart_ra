part of 'methods.dart';

typedef _Registry = Map<String, List<MethodDecl>>;

final class PostmanCollectionMethod extends Method<JsonType> {
  final String methodName;
  final String collectionName;
  final Uri host;
  final Map<String, String?>? variables;

  PostmanCollectionMethod({
    required this.collectionName,
    required this.host,
    this.methodName = 'postman',
    this.variables,
  });
  @override
  ResponseContentType<JsonType> get contentType => JsonContentType();

  List<JsonType> _items(List<MethodDecl> items) {
    final registry = _buildRegistry(items);
    final res = <JsonType>[];
    for (final package in registry.keys) {
      final methods = registry[package]!;
      final node = {'name': package, 'item': methods.map(_declToItem).toList()};

      res.add(node);
    }
    return res;
  }

  @override
  Future<MethodResponse<JsonType>> handle(MethodCtx ctx) async {
    return response
      ..body({
        'info': _info(),
        'item': _items(ctx.methods).toList(growable: false),
        'variable': _variables(),
      });
  }

  _Registry _buildRegistry(List<MethodDecl> items) {
    return items.fold({}, (acc, decl) {
      if (acc.containsKey(decl.package)) {
        acc[decl.package]!.add(decl);
      } else {
        acc.putIfAbsent(decl.package, () => [decl]);
      }

      return acc;
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
      return element.source == DataSource.header;
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
      'query': decl.parameters
          .where((e) => e.source == DataSource.query)
          .map(_paramToQuery)
          .toList(growable: false),
    };
  }

  JsonType _paramToQuery(Parameter param) {
    final value =
        variables?.containsKey(param.id) == true ? '{{${param.id}}}' : '';
    final label = param.isRequired ? '[required] ' : '';
    return {
      'key': param.id,
      'value': value,
      'description': '$label${param.summary ?? ''}'.trimRight(),
    };
  }

  @override
  String get name => methodName;
}
