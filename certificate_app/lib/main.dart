import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/widgets/navigation_rail.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/certificates/records_screen.dart';
import 'features/certificates/issue_screen.dart';
import 'features/templates/customizer_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/auth/login_screen.dart';
import 'services/auth_service.dart';
import 'core/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(const CertifyProApp());
}

class CertifyProApp extends StatelessWidget {
  const CertifyProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CertifyPro',
      theme: CertifyProTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocalUser?>(
      stream: AuthService().user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: snapshot.hasData ? const RootNavigation() : const LoginScreen(),
        );
      },
    );
  }
}

class RootNavigation extends StatefulWidget {
  const RootNavigation({super.key});

  @override
  State<RootNavigation> createState() => _RootNavigationState();
}

class _RootNavigationState extends State<RootNavigation> {
  int _selectedIndex = 0;

  void _onNavigate(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            CertifyProNavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                if (index == 5) {
                   AuthService().signOut();
                } else {
                  _onNavigate(index);
                }
              },
            ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0.02, 0), end: Offset.zero).animate(animation),
                  child: child,
                ),
              ),
              child: _buildScreen(_selectedIndex),
            ),
          ),
        ],
      ),
      bottomNavigationBar: !isDesktop
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                if (index == 4) {
                   AuthService().signOut();
                } else {
                  _onNavigate(index);
                }
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: CertifyProTheme.primary,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Console'),
                BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Logs'),
                BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), activeIcon: Icon(Icons.add_circle), label: 'Issue'),
                BottomNavigationBarItem(icon: Icon(Icons.palette), label: 'Branding'),
                BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Exit'),
              ],
            )
          : null,
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0: return DashboardScreen(key: const ValueKey(0), onQuickIssue: () => _onNavigate(2));
      case 1: return const RecordsScreen(key: ValueKey(1));
      case 2: return const IssueCertificateScreen(key: ValueKey(2));
      case 3: return const TemplateCustomizerScreen(key: ValueKey(3));
      case 4: return const SettingsScreen(key: ValueKey(4));
      default: return DashboardScreen(onQuickIssue: () => _onNavigate(2));
    }
  }
}
