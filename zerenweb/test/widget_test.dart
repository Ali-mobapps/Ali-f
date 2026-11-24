import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:zerenweb/app.dart';
import 'package:zerenweb/providers/product_provider.dart';
import 'package:zerenweb/providers/cart_provider.dart';
import 'package:zerenweb/providers/profile_provider.dart';
import 'package:zerenweb/providers/order_provider.dart';
import 'package:zerenweb/providers/drive_backup_provider.dart';

void main() {
  testWidgets('ZerenApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => OrderProvider()),
          ChangeNotifierProvider(create: (_) => DriveBackupProvider()),
        ],
        child: const ZerenApp(),
      ),
    );

    // Verify that splash screen loads
    expect(find.text('ZEREN WATCHES'), findsOneWidget);

    // Advance time to complete splash screen timer
    await tester.pump(const Duration(seconds: 3));
  });
}
