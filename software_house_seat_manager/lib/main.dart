import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme.dart';
import 'providers/booking_provider.dart';
import 'models/user_model.dart';
import 'screens/login_screen.dart';
import 'screens/student_home_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/pending_approval_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://oebgxcvhbyhdjmqipcib.supabase.co',
    publishableKey: 'sb_publishable_jaP8xAm_0XhA6LbnjckLnw_yXjBv80V',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookingProvider()),
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
      title: 'Kinetic Grid',
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final user = bookingProvider.currentUser;
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      return const LoginScreen();
    }
    
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (user.role == UserRole.admin) {
      return const AdminDashboardScreen();
    } else if (!user.isApproved) {
      return const PendingApprovalScreen();
    } else {
      return const StudentHomeScreen();
    }
  }
}
