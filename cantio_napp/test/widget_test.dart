import 'package:flutter_test/flutter_test.dart';
import 'package:cantio_napp/main.dart';

void main() {
  testWidgets('App starts smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SmartCampusCanteenEngine());

    // Verify that the setup screen is shown
    expect(find.text('Student Profile Setup'), findsOneWidget);
  });
}
