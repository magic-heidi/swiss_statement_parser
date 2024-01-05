import 'dart:io';

import 'package:swiss_statement_parser/index.dart';
import 'package:test/test.dart';

List<Statement> getEntries(String path) => StatementParser.fromFile(File(path).readAsBytesSync());

void main() {
  final list = getEntries('example/assets/ops.xlsx');

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
}
