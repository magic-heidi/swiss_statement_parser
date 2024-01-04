import 'dart:io';

import 'package:excel/excel.dart';
import 'package:logger/logger.dart';
import 'package:test/test.dart';

var file = 'assets/booking.xlsx';
var bytes = File(file).readAsBytesSync();
var excel = Excel.decodeBytes(bytes);

var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2, // Number of method calls to be displayed
    errorMethodCount: 8, // Number of method calls if stacktrace is provided
    lineLength: 120, // Width of the output
    colors: true, // Colorful log messages
    printEmojis: true, // logger.d an emoji for each log message
    printTime: false, // Should each log logger.d contain a timestamp
  ),
);

parse() async {
  // Get all rows
  final entries = excel.tables.values.expand((e) => e.rows);

  // Get rows with dates
  final validEntries = entries.where((data) {
    final index = data.indexWhere((item) {
      final value = item?.value;
      if (value == null) return false;
      logger.d('element $value, ${value.runtimeType}, ${value is DateCellValue}');

      return value is DateCellValue;
    });

    return index >= 0;
  });

  logger.d('Total items ${entries.length}');
  logger.d('Valid items ${validEntries.length}');

  return true;
}

void main() {
  test('works', () {
    parse();
  });
}
