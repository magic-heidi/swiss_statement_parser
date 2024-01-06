import 'dart:developer';
import 'dart:io';

import 'package:swiss_statement_parser/index.dart';

void main() {
  final list = StatementParser.fromCSV(
    File('assets/booking.csv').readAsBytesSync(),
  );

  final matches = list.any((item) => item.match(
        texts: ['Clearing', 'payment', 'jargon', 'values', 'hello world'],
        amount: 3377.05,
        date: DateTime(2024, 1, 5),
      ));

  log('matches $matches');
}
