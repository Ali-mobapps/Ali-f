import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/values/languages.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/inventory/presentation/pages/inventory_page.dart';
import 'features/pos/presentation/pages/pos_page.dart';
import 'features/sales/presentation/pages/sales_history_page.dart';
import 'features/ledger/presentation/pages/ledger_page.dart';
import 'features/insights/presentation/pages/insights_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/auth/presentation/pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qqwgljknlvkxkrgafdqk.supabase.co',
    publishableKey: 'sb_publishable_J6azRJWoDpS8tcw2k_4rBw_EKhCWaff',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Local Shop Store Manager',
      translations: Languages(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/inventory', page: () => const InventoryPage()),
        GetPage(name: '/pos', page: () => const POSPage()),
        GetPage(name: '/history', page: () => const SalesHistoryPage()),
        GetPage(name: '/ledger', page: () => const LedgerPage()),
        GetPage(name: '/insights', page: () => const InsightsPage()),
        GetPage(name: '/settings', page: () => const SettingsPage()),
        GetPage(name: '/profile', page: () => const ProfilePage()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
