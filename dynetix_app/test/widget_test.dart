import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dynetix_app/features/dashboard/presentation/pages/dashboard_page.dart';

void main() {
  testWidgets('Dashboard smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: DashboardPage(),
      ),
    );

    // Verify that dashboard title exists.
    expect(find.text('Dynetix Dashboard'), findsOneWidget);
  });
}