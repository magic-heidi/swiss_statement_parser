import 'dart:io';

import 'package:flutter_test/flutter_test.dart' show TestWidgetsFlutterBinding;
import 'package:swiss_statement_parser/index.dart';
import 'package:test/test.dart';

logStatements(List<Statement> list) {
  for (final item in list) {
    print('--\n\nStatement:\namounts: ${item.amounts}\ndates: ${item.dates}\ntexts: ${item.texts}');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('can parse excel', () {
    final list = StatementParser.fromExcel(
      File('example/assets/ops.xlsx').readAsBytesSync(),
    );

    test('should match statement', () {
      final matches = list.any((item) => item.match(
            texts: ['gland', 'carte', 'null values'],
            amount: 100,
            date: DateTime(2023, 12, 31),
          ));

      expect(matches, true);
    });

    test('should not match statement', () {
      final matches = list.any((item) => item.match(
            texts: ['gland', 'carte'],
            amount: 200,
            date: DateTime(2023, 12, 31),
          ));

      expect(matches, false);
    });
  });

  group('can parse csv', () {
    parseCSV(String path) => StatementParser.fromCSV(File(path).readAsBytesSync());

    final list = parseCSV('example/assets/booking.csv');
    logStatements(list);

    test('should match statement', () {
      final matches = list.any((item) => item.match(
            texts: ['Payment'],
            amount: 1338.75,
            date: DateTime(2024, 01, 03),
          ));

      expect(matches, true);
    });

    test('should not match statement', () {
      final matches = list.any((item) => item.match(
            texts: ['Test', 'Company', 'AG'],
            amount: 100,
            date: DateTime(2023, 11, 1),
          ));

      expect(matches, false);
    });

    test('can parse csv with ; field delimeter', () {
      final list = StatementParser.fromCSV(
        File('example/assets/messy-file.csv').readAsBytesSync(),
      );

      final matches = list.any(
        (item) => item.match(
          texts: ['Reason'],
          amount: 11657.0,
          date: DateTime.parse('2023-06-13'),
          debug: true,
        ),
      );

      expect(matches, true);
    });

    test('can parse different encoding', () {
      parseCSV('example/assets/encoding-ansi.csv');
    });
  });
}
