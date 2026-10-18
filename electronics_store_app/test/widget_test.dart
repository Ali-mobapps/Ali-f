// This is a basic Flutter widget test.
//
// To learn / import statements and test APIs,
// see the https://flutter.dev/docs/cookbook/testing/widget/tests.
//

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:electronics_store_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ElectroStoreApp());

    // Verify login screen appears
    expect(find.text('ElectroStore Pro'), findsOneWidget);
  });
}
