import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:book_store_app/core/theme/app_theme.dart';
import 'package:book_store_app/features/home/presentation/pages/home_page.dart';
import 'package:book_store_app/features/inventory/presentation/pages/inventory_page.dart';
import 'package:book_store_app/features/pos/presentation/pages/pos_page.dart';
import 'package:book_store_app/features/sales/presentation/pages/sales_history_page.dart';
import 'package:book_store_app/features/ledger/presentation/pages/ledger_page.dart';
import 'package:book_store_app/features/insights/presentation/pages/insights_page.dart';
import 'package:book_store_app/features/settings/presentation/pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qqwgljknlvkxkrgafdqk.supabase.co',
    anonKey: 'sb_publishable_J6azRJWoDpS8tcw2k_4rBw_EKhCWaff',
    // Alternatively, for newer versions:
    // publishableKey: 'sb_publishable_J6azRJWoDpS8tcw2k_4rBw_EKhCWaff',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Shop Store Manager',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/inventory': (context) => const InventoryPage(),
        '/pos': (context) => const POSPage(),
        '/history': (context) => const SalesHistoryPage(),
        '/ledger': (context) => const LedgerPage(),
        '/insights': (context) => const InsightsPage(),
        '/settings': (context) => const SettingsPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
