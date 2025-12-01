import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:planner_plus/main.dart' as app;

void main() {
  testWidgets('app starts', (tester) async {
    await tester.pumpWidget(const app.App());
    await tester.pumpAndSettle();
    expect(find.text('Planner+'), findsOneWidget);
  });
}
