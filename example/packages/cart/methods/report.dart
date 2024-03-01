import 'dart:typed_data';

import 'package:essential_xlsx/essential_xlsx.dart';
import 'package:mab/mab.dart';

import '../../../implements/implements.dart';

final class ReportMethod extends ProxyMethod {
  @override
  Future<MethodProxyResponse> handle(MethodContext ctx) async {
    final fromDate = ctx.value<DateTime>('from');
    final to = fromDate.add(Duration(days: ctx.value<int>('count')));

    final person = ctx.value<Person>('body');
    print(person.name);

    print('from $fromDate to $to');

    final List<Map<String, dynamic>> data = <Map<String, dynamic>>[
      {'name': 'Isaque', 'phone': '22 2777-2339', 'age': '32'},
      {'name': 'Joe', 'phone': '22 2777-2339', 'age': '32'},
      {'name': 'Leo', 'phone': '22 2777-2339', 'age': '32'},
      {'name': 'Tiago', 'phone': '22 2777-2339', 'age': '32'},
      {'name': 'Jon', 'phone': '22 2777-2339', 'age': '32'},
    ];

    final simplexlsx = SimpleXLSX();
    simplexlsx.sheetName = 'sheet';

    var idx = 0;
    for (var item in data) {
      if (idx == 0) {
        simplexlsx.addRow(item.keys.toList());
      }
      simplexlsx.addRow(item.values.map((i) => i.toString()).toList());
      idx++;
    }

    final bytes = simplexlsx.build();

    return response..body(Uint8List.fromList(bytes));
  }

  @override
  List<MethodParameter> get params {
    return [
      MethodQueryParameter(id: 'from', dataType: DateTimeDataType()),
      MethodQueryParameter(
        id: 'count',
        dataType: IntDataType(initial: 5),
        optional: true,
      ),
      MethodQueryParameter(
        id: 'search',
        dataType: StringDataType(
          pattern: RegExp(r'^\d{3}-\d{2}$'),
          trim: true,
        ),
      ),
      LimitParameter(),
      MethodBodyParameter(
        dataType: ModelBodyDataType<Person>(
          onTransform: Person.fromJson,
        ),
      ),
    ];
  }

  @override
  String get mimeType {
    return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
  }

  @override
  String get name => 'report';
}

/// Пример модели
final class Person {
  final String name;
  final int age;

  const Person({required this.name, required this.age});

  factory Person.fromJson(JsonType json) {
    return Person(
      name: json['name'],
      age: json['age'],
    );
  }
}
