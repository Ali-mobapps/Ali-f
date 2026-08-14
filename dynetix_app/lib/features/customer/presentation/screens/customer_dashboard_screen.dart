import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dynetix_widgets.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../services/presentation/bloc/services_cubit.dart';
import '../../../services/presentation/bloc/services_state.dart';
import '../../../services/domain/entities/service_entity.dart';
import '../../../payments/presentation/bloc/payment_cubit.dart';
import '../../../payments/presentation/bloc/payment_state.dart' as pay_state;
import '../../../inquiries/presentation/screens/inquiry_chat_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  State<CustomerDashboardScreen> createState() => _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ServicesCubit>().fetchServices();
    context.read<PaymentCubit>().fetchPaymentMethods();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    String userName = "Elite Member";
    String userEmail = "";

    if (authState is AuthAuthenticated) {
      userName = authState.user.name ?? "Alexander";
      userEmail = authState.user.email;
    }

    final List<Widget> pages = [
      _CustomerHomeTab(userName: userName),
      const _CustomerServicesTab(),
      const _CustomerAcademyTab(),
      const _CustomerPaymentsTab(),
      ProfileScreen(userEmail: userEmail),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('DYNETIX', style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: DynetixLogo(size: 32, showGlow: false),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded, color: AppColors.primary)),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Vault'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Solutions'),
          BottomNavigationBarItem(icon: Icon(Icons.school_rounded), label: 'Academy'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Assets'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}

class _CustomerHomeTab extends StatelessWidget {
  final String userName;
  const _CustomerHomeTab({required this.userName});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.glassBorder)),
                child: const ClipOval(
                  child: Icon(Icons.person, size: 40, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Welcome back,', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  Text(userName, style: const TextStyle(color: AppColors.softIvory, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 40),
          
          GlassPanel(
            padding: 28,
            backgroundColor: AppColors.primary.withOpacity(0.05),
            borderColor: AppColors.primary.withOpacity(0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.diamond_rounded, color: AppColors.primary, size: 32),
                const SizedBox(height: 16),
                const Text('Global Concierge', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 8),
                const Text('24/7 priority access to elite professional solutions and certified training.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5)),
                const SizedBox(height: 24),
                DynetixButton(text: 'PRIORITY INQUIRY', onPressed: () {})
              ],
            ),
          ),
          
          const SizedBox(height: 48),
          const Text('Recent Transmissions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
          const SizedBox(height: 20),
          _buildActivityItem(Icons.flight_takeoff_rounded, 'Solution Deployment Confirmed', '2 hours ago'),
          _buildActivityItem(Icons.document_scanner_rounded, 'Q4 Curricula Review Available', 'Yesterday'),
        ],
      ),
    );
  }

  Widget _buildActivityItem(IconData icon, String title, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassPanel(
        padding: 4,
        child: ListTile(
          leading: Icon(icon, color: AppColors.primary, size: 20),
          title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
          subtitle: Text(time, style: const TextStyle(color: AppColors.textDisabled, fontSize: 11)),
          trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textDisabled),
        ),
      ),
    );
  }
}

class _CustomerServicesTab extends StatelessWidget {
  const _CustomerServicesTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        if (state is ServicesLoading) return const Center(child: CircularProgressIndicator());
        if (state is ServicesLoaded) {
          final services = state.services.where((s) => s.type == 'service').toList();
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: services.length,
            itemBuilder: (context, index) => _buildConsumerCard(context, services[index]),
          );
        }
        return const Center(child: Text('No services available.'));
      },
    );
  }
}

class _CustomerAcademyTab extends StatelessWidget {
  const _CustomerAcademyTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        if (state is ServicesLoading) return const Center(child: CircularProgressIndicator());
        if (state is ServicesLoaded) {
          final courses = state.services.where((s) => s.type == 'course').toList();
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: courses.length,
            itemBuilder: (context, index) => _buildConsumerCard(context, courses[index]),
          );
        }
        return const Center(child: Text('No courses available.'));
      },
    );
  }
}

class _CustomerPaymentsTab extends StatelessWidget {
  const _CustomerPaymentsTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, pay_state.PaymentState>(
      builder: (context, state) {
        if (state is pay_state.PaymentLoading) return const Center(child: CircularProgressIndicator());
        if (state is pay_state.PaymentLoaded) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Secure Assets', style: TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.bold)),
                const Text('Manage your capital and payment configurations.', style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.payments.length,
                    itemBuilder: (context, index) {
                      final method = state.payments[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: GlassPanel(
                          padding: 20,
                          child: Row(
                            children: [
                              const Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 28),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(method.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                                    Text(method.accountNumber, style: const TextStyle(color: AppColors.textDisabled, fontSize: 14)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy_rounded, color: AppColors.primary),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: method.accountNumber));
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied!')));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: Text('Error loading assets.'));
      },
    );
  }
}

Widget _buildConsumerCard(BuildContext context, ServiceEntity item) {
  final TextEditingController _inquiryController = TextEditingController();
  final authState = context.read<AuthCubit>().state;
  String userId = "anonymous";
  if (authState is AuthAuthenticated) userId = authState.user.id;

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    child: GlassPanel(
      padding: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
              Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(item.description, style: const TextStyle(color: AppColors.textDisabled, fontSize: 12)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(16)),
                  child: TextField(
                    controller: _inquiryController,
                    decoration: const InputDecoration(
                      hintText: 'Ask us something...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 12, color: AppColors.textDisabled),
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => InquiryChatScreen(
                    itemId: item.id, 
                    itemTitle: item.title, 
                    userRole: 'customer', 
                    userId: userId
                  )));
                },
                child: Container(
                  height: 48, width: 48,
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.send_rounded, color: AppColors.primary, size: 20),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
