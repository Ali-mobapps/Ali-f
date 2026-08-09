import 'package:dynetix_app/core/services/database_service.dart';
import 'package:dynetix_app/core/services/hive_service.dart';
import 'package:dynetix_app/presentation/auth/bloc/auth_bloc.dart';
import 'package:dynetix_app/presentation/auth/bloc/auth_event.dart';
import 'package:dynetix_app/presentation/auth/login_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();

  await Supabase.initialize(
    url: 'https://sqoaobghpkfjcgghalgs.supabase.co',
    publishableKey: 'sb_publishable_Qx1krqXcM7_0mXoIvdbb9A_D1vfqLqy',
  );

  runApp(
    BlocProvider(
      create: (context) => AuthBloc()..add(AppStarted()),
      child: const DynetixApp(),
    ),
  );
}

class DynetixApp extends StatefulWidget {
  const DynetixApp({super.key});

  static DynetixAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<DynetixAppState>();

  @override
  State<DynetixApp> createState() => DynetixAppState();
}

class DynetixAppState extends State<DynetixApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  void refreshTheme() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = false;
    try {
      isDark = AppDatabase.isDarkMode;
    } catch (_) {
      isDark = false;
    }

    return MaterialApp(
      title: 'Dynetix Pro',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ur'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0052CC)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0052CC),
          brightness: Brightness.dark,
          surface: const Color(0xFF1E293B),
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          color: Color(0xFF1E293B),
          elevation: 0,
        ),
      ),
      home: const LoginSelectionPage(),
    );
  }
}
