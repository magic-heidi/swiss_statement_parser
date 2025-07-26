import 'dart:convert';

import 'package:charset/charset.dart';
import 'package:collection/collection.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:swiss_statement_parser/models.dart';

Iterable<StatementRow> decodeXLSX(Uint8List bytes) {
  final excel = SpreadsheetDecoder.decodeBytes(bytes);
  return excel.tables.values.expand((e) => e.rows);
}

bool isSingleColumnCSV(List<List<dynamic>> data) => !data.any((row) => row.length > 1);

Iterable<StatementRow> decodeCSV(Uint8List bytes) {
  String? input;

  // Decode bytes
  {
    final encoders = [utf8, windows1252, ascii, latin1, utf16];

    for (final encoder in encoders) {
      try {
        input = encoder.decode(bytes);
        break;
      } catch (_) {}
    }

    if (input == null) throw Exception('Failed to decode given bytes');
  }

  var data = const CsvToListConverter().convert(
    input,
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
