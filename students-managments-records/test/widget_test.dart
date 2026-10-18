import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:students_managments_records/app.dart';
import 'package:students_managments_records/providers/auth_provider.dart';
import 'package:students_managments_records/providers/backup_restore_provider.dart';
import 'package:students_managments_records/providers/student_provider.dart';
import 'package:students_managments_records/providers/theme_provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => StudentProvider()),
          ChangeNotifierProvider(create: (_) => BackupRestoreProvider()),
        ],
        child: const StudentManagementApp(),
      ),
    );

    expect(find.byType(StudentManagementApp), findsOneWidget);

    // Pump timer duration without waiting for infinite animation to settle
    await tester.pump(const Duration(seconds: 3));
  });
}
