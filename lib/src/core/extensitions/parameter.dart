part of 'extensions.dart';

extension ParameterExt<I, O> on Parameter<I, O> {
  /// Extracts the value of the parameter from the provided data source context.
  I? extract(DataSourceContext ctx) {
    switch (source) {
      case DataSource.query:
        return ctx.query(id) as I?;
      case DataSource.header:
        return ctx.header(id) as I?;
      case DataSource.body:
        return ctx.body.isNotEmpty ? ctx.body as I : null;
    }
  }
}
