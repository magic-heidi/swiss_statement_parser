import 'dart:io';

import 'package:swiss_statement_parser/index.dart';
import 'package:test/test.dart';

void main() {
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
    final list = StatementParser.fromCSV(
      File('example/assets/booking.csv').readAsBytesSync(),
    );

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
  });
}
