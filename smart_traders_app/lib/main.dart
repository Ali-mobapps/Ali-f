import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://vlxizkkmniqpluzvloqj.supabase.co',
    anonKey: 'sb_publishable_lYbpKL0w6a6hSnAbSWgZcQ_1UCP2wN-',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Traders',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A), // Vibrant Royal Blue
          primary: const Color(0xFF1E3A8A),
          secondary: const Color(0xFFF59E0B), // VIP Amber/Gold
          surface: const Color(0xFFF0F9FF), // Very Light Blue Surface
        ),
        textTheme: GoogleFonts.hankenGroteskTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.bold, 
            fontSize: 20, 
            letterSpacing: 1.2
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 8,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          shadowColor: Colors.black26,
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final session = snapshot.hasData ? snapshot.data!.session : null;
        return session != null ? const HomeScreen() : const AuthScreen();
      },
    );
  }
}
