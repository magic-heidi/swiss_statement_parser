import 'dart:io';

import 'package:swiss_statement_parser/index.dart';
import 'package:test/test.dart';

void main() {
  group('can parse excel', () {
    final list = StatementParser.fromExcel(
      File('example/assets/ops.xlsx').readAsBytesSync(),
    );

    test('should match statement', () {
      final matches = list.first.match(
        texts: ['gland', 'carte'],
        amounts: [100],
        dates: [DateTime(2023, 12, 31)],
      );

      expect(matches, true);
    });

    test('should not match statement', () {
      final matches = list.first.match(
        texts: ['gland', 'carte'],
        amounts: [200],
        dates: [DateTime(2023, 12, 31)],
      );

      expect(matches, false);
    });
  });

  group('can parse csv', () {
    final list = StatementParser.fromCSV(
      File('example/assets/statement.csv').readAsBytesSync(),
    );

    for (var element in list) {
      print('${element.texts} ${element.amounts} ${element.dates}');
    }

    test('should match statement', () {
      final matches = list.first.match(
        texts: ['Test', 'Company', 'AG'],
        amounts: [35548],
        dates: [DateTime(2023, 8, 2)],
      );

      expect(matches, true);
    });

    test('should not match statement', () {
      final matches = list.first.match(
        texts: ['Test', 'Company', 'AG'],
        amounts: [100],
        dates: [DateTime(2023, 11, 1)],
      );

      expect(matches, false);
    });
  });
}
