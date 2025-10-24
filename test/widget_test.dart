import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:action_immobiliaria/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ActionImmobiliariaApp());

    // Verify that our app starts correctly
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
