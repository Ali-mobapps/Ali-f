import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data_service.dart';
import 'notifier.dart';
import 'splash_screen.dart';
import 'models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: DataService.supabaseUrl,
    anonKey: DataService.supabaseKey,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech House',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: AppNotifier.messengerKey,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onSecondary,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          error: AppColors.error,
          onError: AppColors.onError,
        ),
        textTheme: GoogleFonts.hankenGroteskTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          labelLarge: GoogleFonts.hankenGrotesk(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          labelMedium: GoogleFonts.hankenGrotesk(
            textStyle: Theme.of(context).textTheme.labelMedium,
          ),
          labelSmall: GoogleFonts.hankenGrotesk(
            textStyle: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceBright,
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.outlineVariant, width: 2),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.secondary, width: 2),
          ),
          labelStyle: GoogleFonts.hankenGrotesk(color: AppColors.onSurfaceVariant),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
