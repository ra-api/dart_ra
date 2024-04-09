import 'package:ra/ra.dart';

final class UtilPackage extends Package {
  const UtilPackage();
  @override
  List<Method<Object>> get methods {
    return [
      PostmanCollectionMethod(
        host: Uri.parse('localhost:3000'),
        collectionName: 'Example Test API',
        methodName: 'postman',
        variables: {'count': '15', 'limit': '20'},
      ),
    ];
  }

  @override
  String get name => 'util';
}
