import 'dart:convert';

import 'package:test/test.dart';

void expectObjectJson(
  Object? actual,
  Object? expected, {
  String? reason,
  skip,
}) {
  final actualJson = jsonDecode(jsonEncode(actual));
  final expectedJson = jsonDecode(jsonEncode(expected));
  expect(
    actualJson,
    expectedJson,
    reason: reason,
    skip: skip,
  );
}
