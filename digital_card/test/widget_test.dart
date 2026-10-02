import 'package:flutter_test/flutter_test.dart';
import 'package:digital_card/main.dart';

void main() {
  testWidgets('Campus dashboard smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StudentDigitalCardApp());

    // Verify that the title and Student ID card exist
    expect(find.text('Campus Dashboard'), findsOneWidget);
    expect(find.text('ALI HASSAN'), findsOneWidget);
    expect(find.text('Reg No: FA24-BSE-013'), findsOneWidget);
  });
}
