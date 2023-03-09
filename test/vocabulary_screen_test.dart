import 'package:flutter/material.dart';
import 'package:flutter_application_1/vocabulary_screen.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('Test VocabularyScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: VocabularyScreen()));

    expect(find.text('Vocabulary Screen'), findsOneWidget);
  });
}
