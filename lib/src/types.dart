import 'package:meta/meta.dart';

typedef JsonType = Map<String, dynamic>;

enum DataSource {
  query('query'),
  header('header'),
  path('path'),
  cookie('cookie'),
  body('body');

  final String source;
  const DataSource(this.source);
}

/// Источники для параметров на уровне метода
enum MethodDataSource {
  query('query'),
  header('header'),
  body('body');

  final String source;
  const MethodDataSource(this.source);

  DataSource toDataSource() {
    return switch (this) {
      MethodDataSource.query => DataSource.query,
      MethodDataSource.header => DataSource.header,
      MethodDataSource.body => DataSource.body,
    };
  }
}

/// Источники для параметров на уровне пакета
enum PackageDataSource {
  header('header'),
  cookie('cookie');

  final String source;
  const PackageDataSource(this.source);

  DataSource toDataSource() {
    return switch (this) {
      PackageDataSource.header => DataSource.header,
      PackageDataSource.cookie => DataSource.cookie,
    };
  }
}

@internal
enum PluginScope {
  global,
  method,
}
