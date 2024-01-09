import 'dart:developer';

import 'package:swiss_statement_parser/utils.dart';

typedef StatementRow = Iterable<dynamic>;

class Statement {
  final List<String> texts;
  final List<double> amounts;
  final List<DateTime> dates;

  const Statement({
    required this.texts,
    required this.amounts,
    required this.dates,
  });

  List<String> get textParts {
    return texts.expand((value) => value.split(' ')).toList();
  }

  /// Matches statement with provided data
  ///
  /// [texts] is matched any item in the list matches with model list items
  ///
  /// [amount] is matched with exact values
  ///
  /// [date] is matched when statement dates are in the future in comparison to input date
  bool match({
    required List<String> texts,
    required double amount,
    required DateTime date,
    bool debug = false,
  }) {
    // Normalize input date
    final inputDate = DateTime(date.year, date.month, date.day);
    final inputTexts = texts.map((e) => e.toLowerCase().trim()).expand((e) => e.split(',')).toList();
    final modelTexts = textParts.map((e) => e.toLowerCase().trim()).expand((e) => e.split(',')).toList();

    // Match texts
    final textsMatched = PatternMatcher.matchLists(inputTexts, modelTexts);

    // Match amount
    final amountMatched = amounts.any((value) => value == amount);

    final dateMatched = dates.any((date) => inputDate.isAtSameMomentAs(date) || inputDate.isBefore(date));

    if (debug) {
      log('-------');
      log('texts:\ninput: $inputTexts\nmodel: ${modelTexts.toString()}\nmatched: $textsMatched');
      log('amounts:\ninput: $amount\nmodel: $amounts\nmatched: $amountMatched');
      log('dates:\ninput: $inputDate\nmodel: $dates\nmatched: $dateMatched');
    }

    return textsMatched && amountMatched && dateMatched;
  }
}
