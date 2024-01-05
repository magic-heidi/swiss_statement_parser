import 'dart:io';

import 'package:swiss_statement_parser/index.dart';

void main() {
  var file = 'assets/ops.xlsx';
  final bytes = File(file).readAsBytesSync();

  final list = StatementParser.fromExcel(bytes);

  print(list.length);
  print('${list.first.textParts}\n ${list.first.amounts}\n${list.first.dates}');

  final matches = list.first.match(
    texts: ['gland', 'carte'],
    amounts: [100],
    dates: [DateTime(2023, 12, 31)],
  );

  print('matches: $matches');
}
