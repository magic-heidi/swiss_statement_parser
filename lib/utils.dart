import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:csv/csv.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:swiss_statement_parser/models.dart';

Iterable<StatementRow> decodeXLSX(Uint8List bytes) {
  final excel = SpreadsheetDecoder.decodeBytes(bytes);
  return excel.tables.values.expand((e) => e.rows);
}

bool isSingleColumnCSV(List<List<dynamic>> data) => !data.any((row) => row.length > 1);

Iterable<StatementRow> decodeCSV(Uint8List bytes) {
  var data = const CsvToListConverter().convert(
    utf8.decode(bytes),
    eol: '\n',
  );

  // Parse legacy CSV
  // If file is ; separated all rows will have one column
  if (isSingleColumnCSV(data)) {
    final result = const CsvToListConverter().convert(
      utf8.decode(bytes).replaceAll(';;', ';'),
      eol: '\n',
      fieldDelimiter: ';',
    );

    if (result.isNotEmpty && !isSingleColumnCSV(result)) data = result;
  }

  // Cleanup data
  data.forEachIndexed((index, row) {
    data[index] = row.where((item) => item is String ? item.isNotEmpty : item != null).toList();
  });

  return data;
}

class PatternMatcher {
  static bool matchLists<T>(Iterable<T> list1, Iterable<T> list2) {
    final set = list1.toSet().intersection(list2.toSet());
    return set.isNotEmpty;
  }
}
