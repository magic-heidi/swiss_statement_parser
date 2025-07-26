import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:datify/datify.dart';
import 'package:swiss_statement_parser/models.dart';
import 'package:swiss_statement_parser/utils.dart';

class StatementParser {
  /// Checks if row is a valid statement
  static isValidRow(List<dynamic> row) {
    return row.any((value) {
      if (value == null) return false;
      return Datify.parse(value.toString()).date != null;
    });
  }

  static Statement parseItem(StatementRow row) {
    final texts = row.whereType<String>();

    final amounts = row.where((value) => value is int || value is double || value is num).map((e) => double.parse(e.toString()));
    final dates = row.map((value) => Datify.parse(value.toString()).date).nonNulls;

    return Statement(amounts: amounts.toList(), dates: dates.toList(), texts: texts.toList());
  }

  static List<Statement> parseRows(Iterable<StatementRow> rows) {
    // return rows.map(parseItem).whereNotNull().toList();

    return rows.expand<Statement>((data) {
      final isValid = isValidRow(data.toList());

      if (!isValid) return [];

      // Cleanup null/empty values
      final row = data.whereNot((element) => element == null || element.toString().trim() == '');

      return [parseItem(row)];
    }).toList();
  }

  static List<Statement> fromExcel(Uint8List bytes) {
    final rows = decodeXLSX(bytes);
    return StatementParser.parseRows(rows);
  }

  static List<Statement> fromCSV(Uint8List bytes) {
    final rows = decodeCSV(bytes);
    return StatementParser.parseRows(rows);
  }
}
