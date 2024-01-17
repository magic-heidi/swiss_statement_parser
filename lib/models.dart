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
  /// [amount] is matched with exact values. By default, amounts will be rounded down to nearest 5 cents
  ///
  /// [date] is matched when statement dates are in the future in comparison to input date
  bool match({
    required List<String> texts,
    required double amount,
    required DateTime date,
    bool debug = false,
    double Function(double value)? roundAmount,
  }) {
    Iterable<String> normalizeTexts(Iterable<String> input) {
      final value = input.map((e) => e.toLowerCase().trim().replaceAll(RegExp(r'[^\w\s]+'), '')).where((e) => e.isNotEmpty);

      return value;
    }

    // By default round down to nearest 5 cents
    final round = roundAmount ?? (double value) => (value * 20).floor() / 20;

    // Normalize input date
    final inputDate = DateTime(date.year, date.month, date.day);
    final inputTexts = normalizeTexts(texts);
    final modelTexts = normalizeTexts(textParts);

    // Match texts
    final textsMatched = PatternMatcher.matchLists(inputTexts, modelTexts);

    // Match amount
    final amountMatched = amounts.any((value) => round(value) == round(amount));

    final dateMatched = dates.any((date) => inputDate.isAtSameMomentAs(date) || inputDate.isBefore(date));

    if (debug) {
      log('-------');
      log('texts:\ninput: $inputTexts\nmodel: $modelTexts\nmatched: $textsMatched');
      log('amounts:\ninput: $amount\nmodel: $amounts\nmatched: $amountMatched');
      log('dates:\ninput: $inputDate\nmodel: $dates\nmatched: $dateMatched');
    }

    return textsMatched && amountMatched && dateMatched;
  }
}
