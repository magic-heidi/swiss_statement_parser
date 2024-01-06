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
  bool match({
    List<String> texts = const [],
    List<double> amounts = const [],
    List<DateTime> dates = const [],
  }) {
    // Match texts
    final textsMatched = PatternMatcher.matchLists(
      texts.map((e) => e.toLowerCase()),
      textParts.map((e) => e.toLowerCase()),
    );

    final amountsMatched = PatternMatcher.matchLists(amounts, this.amounts);

    final datesMatched = PatternMatcher.matchLists(
      // Reset input datetime
      dates.map((e) => DateTime(e.year, e.month, e.day)),
      this.dates,
    );

    return textsMatched && amountsMatched && datesMatched;
  }
}
