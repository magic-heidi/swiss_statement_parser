import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:swiss_statement_parser/models.dart';

(DateTime? value, bool isValid) parseDate(String input) {
  final value = DateFormat("dd.MM.yyyy").tryParse(input);
  final isValid = value != null;

  return (value, isValid);
}

Iterable<StatementRow> decodeXLSX(Uint8List bytes) {
  final excel = SpreadsheetDecoder.decodeBytes(bytes);
  return excel.tables.values.expand((e) => e.rows);
}

class PatternMatcher {
  static bool matchLists<T>(Iterable<T> list1, Iterable<T> list2) {
    final set = list1.toSet().intersection(list2.toSet());
    return set.isNotEmpty;
  }
}
