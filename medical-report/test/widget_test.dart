import 'package:flutter_test/flutter_test.dart';
import 'package:medical_report/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyMedicalHistoryApp());
    expect(find.byType(MyMedicalHistoryApp), findsOneWidget);
  });
}
