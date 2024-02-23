typedef JsonType = Map<String, dynamic>;

/// Источники для параметров на уровне метода
enum MethodDataSource {
  query('query'),
  header('header'),
  body('body');

  final String source;
  const MethodDataSource(this.source);
}

/// Источники для параметров на уровне пакета
enum PackageDataSource {
  header('header'),
  cookie('cookie');

  final String source;
  const PackageDataSource(this.source);
}
