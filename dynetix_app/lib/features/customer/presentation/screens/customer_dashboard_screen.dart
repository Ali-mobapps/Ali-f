import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/vip_theme.dart';
import '../../../../core/widgets/dynetix_widgets.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../services/presentation/screens/services_screen.dart';
import '../../../services/presentation/screens/academy_screen.dart';
import '../../../payments/presentation/screens/payment_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

class CustomerDashboardScreen extends StatefulWidget {
  final String customerEmail;

  const CustomerDashboardScreen({
    super.key,
    this.customerEmail = 'customer@dynetix.com',
  });

  @override
  State<CustomerDashboardScreen> createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _HomeTabContent(customerEmail: widget.customerEmail),
      const ServicesScreen(isAdmin: false),
      const AcademyScreen(),
      const PaymentScreen(isAdmin: false),
      ProfileScreen(userEmail: widget.customerEmail),
    ];

    return Scaffold(
      backgroundColor: VIPTheme.darkBackground,
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: VIPTheme.cardBackground,
        selectedItemColor: VIPTheme.primaryGold,
        unselectedItemColor: Colors.white54,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), activeIcon: Icon(Icons.grid_view_rounded), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: 'Academy'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), activeIcon: Icon(Icons.account_balance_wallet_rounded), label: 'Payment'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), activeIcon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}

class _HomeTabContent extends StatelessWidget {
  final String customerEmail;

  const _HomeTabContent({required this.customerEmail});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        String displayName = customerEmail.split('@').first;
        if (state is AuthAuthenticated && state.user.name != null) {
          displayName = state.user.name!;
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo and Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const DynetixLogo(size: 60),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: VIPTheme.primaryGold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: VIPTheme.primaryGold.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.star_rounded, color: VIPTheme.primaryGold, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'VIP ACCESS',
                            style: TextStyle(color: VIPTheme.primaryGold, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'Welcome to',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                Text(
                  'Dynetix, $displayName',
                  style: const TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.bold, 
                    color: VIPTheme.primaryGold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: VIPTheme.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.white54, size: 20),
                      SizedBox(width: 12),
                      Text('Search for solutions...', style: TextStyle(color: Colors.white54)),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Services Quick Access
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Featured Services', 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {}, 
                      child: const Text('View All', style: TextStyle(color: VIPTheme.primaryGold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Grid of Categories
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.4,
                  children: [
                    _buildCategoryCard(Icons.code_rounded, 'Development', 'Modern Solutions'),
                    _buildCategoryCard(Icons.brush_rounded, 'UI/UX Design', 'Elite Creative'),
                    _buildCategoryCard(Icons.auto_awesome_rounded, 'AI & Python', 'Future Tech'),
                    _buildCategoryCard(Icons.trending_up_rounded, 'Digital Marketing', 'Scale Fast'),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Banner Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFB8860B), VIPTheme.primaryGold],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: VIPTheme.primaryGold.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Master New Skills',
                              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Join our premium academy and learn from industry experts.',
                              style: TextStyle(color: Colors.black87, fontSize: 12),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: VIPTheme.primaryGold,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Explore Academy', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.school_rounded, size: 80, color: Colors.black12),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VIPTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: VIPTheme.primaryGold.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: VIPTheme.primaryGold, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white54, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
