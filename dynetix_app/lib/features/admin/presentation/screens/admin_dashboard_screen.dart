import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dynetix_widgets.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/screens/role_selection_screen.dart';
import '../../../services/data/repositories/services_repository_impl.dart';
import '../../../services/presentation/bloc/services_cubit.dart';
import '../../../services/presentation/bloc/services_state.dart';
import '../../../services/domain/entities/service_entity.dart';
import '../../../payments/data/repositories/payment_methods_repository_impl.dart';
import '../../../payments/presentation/bloc/payment_cubit.dart';
import '../../../payments/presentation/bloc/payment_state.dart' as pay_state;
import '../../../payments/domain/entities/payment_method_entity.dart';
import '../../../inquiries/presentation/bloc/inquiries_cubit.dart';
import '../../../inquiries/presentation/bloc/inquiries_state.dart';
import '../../../inquiries/presentation/screens/inquiry_chat_screen.dart';
import '../../../inquiries/domain/entities/inquiry_entity.dart';
import '../../../orders/presentation/bloc/orders_cubit.dart';
import '../../../orders/presentation/bloc/orders_state.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../profile/presentation/bloc/profile_cubit.dart';
import '../../../profile/presentation/bloc/profile_state.dart' as profile_state;
import '../../../profile/presentation/screens/edit_profile_screen.dart';
import '../../../profile/presentation/screens/settings_features_screens.dart';

// Mapping icons for services
IconData _getServiceIcon(String title, String type) {
  if (type == 'course') return Icons.school_rounded;
  title = title.toLowerCase();
  if (title.contains('modeling')) return Icons.view_in_ar_rounded;
  if (title.contains('drafting')) return Icons.gavel_rounded;
  if (title.contains('shopify')) return Icons.shopping_bag_rounded;
  if (title.contains('game') || title.contains('app')) return Icons.phonelink_setup_rounded;
  if (title.contains('ui/ux') || title.contains('design')) return Icons.palette_rounded;
  if (title.contains('seo')) return Icons.search_rounded;
  if (title.contains('marketing')) return Icons.campaign_rounded;
  if (title.contains('writing')) return Icons.history_edu_rounded;
  if (title.contains('video')) return Icons.video_camera_back_rounded;
  if (title.contains('wordpress')) return Icons.web_rounded;
  if (title.contains('payment')) return Icons.payments_rounded;
  return Icons.miscellaneous_services_rounded;
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load initial data from Supabase
    context.read<ServicesCubit>().fetchServices();
    context.read<PaymentCubit>().fetchPaymentMethods();
    context.read<OrdersCubit>().watchAllOrders();

    // Fetch admin profile early
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.read<ProfileCubit>().fetchProfile(authState.user.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const _InsightsDashboard(),
      const _ServicesDashboard(),
      const _AcademyDashboard(),
      const _OrdersDashboard(),
      const _PaymentsDashboard(),
      const _CustomerMessagesDashboard(),
      const _AdminProfileDashboard(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('DYNETIX ADMIN',
            style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: DynetixLogo(size: 32, showGlow: false),
        ),
      ),
      body: pages[_selectedIndex >= pages.length ? 0 : _selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex >= pages.length ? 0 : _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textDisabled,
        backgroundColor: AppColors.surface,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: 'Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.school_rounded), label: 'Academy'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_rounded), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Payments'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}

class _InsightsDashboard extends StatelessWidget {
  const _InsightsDashboard();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OrdersCubit, OrdersState>(
            listener: (context, state) {}), // Ensure listening
      ],
      child: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, orderState) {
          return BlocBuilder<ServicesCubit, ServicesState>(
            builder: (context, serviceState) {
              int totalOrders = 0;
              int activeOrders = 0;
              int completedOrders = 0;
              double totalEarnings = 0;
              int totalServices = 0;

              if (orderState is OrdersLoaded) {
                totalOrders = orderState.orders.length;
                activeOrders = orderState.orders
                    .where((o) =>
                        o.status == 'in_progress' || o.status == 'pending')
                    .length;
                completedOrders =
                    orderState.orders.where((o) => o.status == 'completed').length;
                totalEarnings = orderState.orders
                    .where((o) => o.paymentStatus == 'paid')
                    .fold(0, (sum, item) => sum + item.price);
              }

              if (serviceState is ServicesLoaded) {
                totalServices = serviceState.services.length;
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Business Intelligence',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    const Text('Real-time performance metrics.',
                        style: TextStyle(color: AppColors.textDisabled)),
                    const SizedBox(height: 32),
                    
                    // Large Earnings Card
                    GlassPanel(
                      padding: 24,
                      borderColor: AppColors.primary.withValues(alpha: 0.3),
                      backgroundColor: AppColors.primary.withValues(alpha: 0.05),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('REVENUE STREAM', style: TextStyle(color: AppColors.textSecondary, letterSpacing: 1, fontSize: 10, fontWeight: FontWeight.bold)),
                              Icon(Icons.trending_up_rounded, color: AppColors.success, size: 20),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text('Rs. ${totalEarnings.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 4),
                          const Text('Total verified earnings to date', style: TextStyle(color: AppColors.textDisabled, fontSize: 11)),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Stats Grid
                    Row(
                      children: [
                        _buildStatCard('Total Projects', totalOrders.toString(), Icons.assignment_rounded, Colors.blueAccent),
                        const SizedBox(width: 16),
                        _buildStatCard('Active Jobs', activeOrders.toString(), Icons.bolt_rounded, Colors.orangeAccent),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildStatCard('Completed', completedOrders.toString(), Icons.check_circle_rounded, AppColors.success),
                        const SizedBox(width: 16),
                        _buildStatCard('Services', totalServices.toString(), Icons.layers_rounded, Colors.purpleAccent),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    const Text('Project Status Distribution', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildDistributionBar('Completed', completedOrders, totalOrders, AppColors.success),
                    _buildDistributionBar('In Progress', activeOrders, totalOrders, Colors.blueAccent),
                    _buildDistributionBar('Pending', totalOrders - activeOrders - completedOrders, totalOrders, Colors.grey),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: GlassPanel(
        padding: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 16),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: AppColors.textDisabled, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionBar(String label, int count, int total, Color color) {
    double percentage = total > 0 ? (count / total) : 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Text('$count', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServicesDashboard extends StatelessWidget {
  const _ServicesDashboard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        if (state is ServicesLoading) return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        if (state is ServicesError) return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.redAccent)));
        
        if (state is ServicesLoaded) {
          final services = state.services.where((s) => s.type == 'service').toList();
          if (services.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.textDisabled),
                  const SizedBox(height: 16),
                  const Text('No services found. Go to Profile to seed data.', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, 'Core Services', 'Manage digital solutions.', () => _showServiceDialog(context, type: 'service')),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => context.read<ServicesCubit>().fetchServices(),
                  color: AppColors.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final item = services[index];
                      return _buildAdminItemCard(
                        title: item.title,
                        price: 'Rs. ${item.price.toStringAsFixed(2)}',
                        type: 'service',
                        onEdit: () => _showServiceDialog(context, service: item),
                        onDelete: () => context.read<ServicesCubit>().deleteService(item.id),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _AcademyDashboard extends StatelessWidget {
  const _AcademyDashboard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        if (state is ServicesLoading) return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        if (state is ServicesError) return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.redAccent)));

        if (state is ServicesLoaded) {
          final courses = state.services.where((s) => s.type == 'course').toList();
          if (courses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school_outlined, size: 64, color: AppColors.textDisabled),
                  const SizedBox(height: 16),
                  const Text('No courses found. Go to Profile to seed data.', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, 'Academy Suite', 'Manage premium curricula.', () => _showServiceDialog(context, type: 'course')),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => context.read<ServicesCubit>().fetchServices(),
                  color: AppColors.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final item = courses[index];
                      return _buildAdminItemCard(
                        title: item.title,
                        price: 'Rs. ${item.price.toStringAsFixed(2)}',
                        type: 'course',
                        onEdit: () => _showServiceDialog(context, service: item),
                        onDelete: () => context.read<ServicesCubit>().deleteService(item.id),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _OrdersDashboard extends StatelessWidget {
  const _OrdersDashboard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (state is OrdersError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off_rounded,
                    size: 48, color: Colors.redAccent),
                const SizedBox(height: 16),
                const Text('Realtime connection issues.',
                    style: TextStyle(color: Colors.white)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(state.message,
                      style: const TextStyle(
                          color: AppColors.textDisabled, fontSize: 10),
                      textAlign: TextAlign.center,
                      maxLines: 2),
                ),
                const SizedBox(height: 24),
                DynetixButton(
                  text: 'RETRY CONNECTION',
                  isOutline: true,
                  onPressed: () => context.read<OrdersCubit>().watchAllOrders(),
                ),
              ],
            ),
          );
        }

        List<OrderEntity> orders = [];
        double totalEarnings = 0;

        if (state is OrdersLoaded) {
          orders = state.orders;
          totalEarnings = orders
              .where((o) => o.paymentStatus == 'paid')
              .fold(0, (sum, item) => sum + item.price);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEarningsHeader(totalEarnings),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Project Tracking',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded,
                        color: AppColors.primary, size: 20),
                    onPressed: () =>
                        context.read<OrdersCubit>().watchAllOrders(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: orders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment_late_outlined,
                              size: 48,
                              color: AppColors.textDisabled.withOpacity(0.2)),
                          const SizedBox(height: 16),
                          const Text('No active projects found.',
                              style: TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return _buildOrderCard(context, orders[index]);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEarningsHeader(double total) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      child: GlassPanel(
        padding: 24,
        borderColor: AppColors.primary.withValues(alpha: 0.3),
        backgroundColor: AppColors.primary.withValues(alpha: 0.05),
        child: Column(
          children: [
            const Icon(Icons.account_balance_wallet_rounded,
                color: AppColors.primary, size: 32),
            const SizedBox(height: 12),
            const Text('TOTAL EARNINGS',
                style: TextStyle(
                    color: AppColors.textSecondary,
                    letterSpacing: 2,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Rs. ${total.toStringAsFixed(2)}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            const Text('Verified through secure payments',
                style: TextStyle(color: AppColors.textDisabled, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderEntity order) {
    Color statusColor;
    switch (order.status) {
      case 'completed':
        statusColor = AppColors.success;
        break;
      case 'in_progress':
        statusColor = Colors.blueAccent;
        break;
      case 'review':
        statusColor = Colors.orangeAccent;
        break;
      default:
        statusColor = AppColors.textDisabled;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassPanel(
        padding: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.serviceTitle,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      Text('Order ID: ${order.id.substring(0, 8)}',
                          style: const TextStyle(
                              color: AppColors.textDisabled, fontSize: 10)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(order.status.toUpperCase(),
                          style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: Colors.redAccent, size: 18),
                      onPressed: () => _showDeleteOrderDialog(context, order),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Rs. ${order.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.bold)),
                if (order.paymentScreenshot != null &&
                    order.paymentScreenshot!.isNotEmpty)
                  TextButton.icon(
                    onPressed: () =>
                        launchUrl(Uri.parse(order.paymentScreenshot!)),
                    icon: const Icon(Icons.image_search_rounded,
                        color: AppColors.gold, size: 18),
                    label: const Text('VIEW PROOF',
                        style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white10),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (order.paymentStatus == 'pending_verification')
                    _buildStatusButton(context, order, 'approve_payment',
                        'VERIFY PAYMENT', Icons.verified_user_rounded,
                        color: AppColors.success),
                  _buildStatusButton(context, order, 'in_progress', 'START',
                      Icons.play_arrow_rounded),
                  const SizedBox(width: 8),
                  _buildStatusButton(context, order, 'review', 'REVIEW',
                      Icons.rate_review_rounded),
                  const SizedBox(width: 8),
                  _buildStatusButton(context, order, 'completed', 'FINISH',
                      Icons.check_circle_rounded),
                ],
              ),
            ),
            if (order.paymentStatus == 'paid')
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle,
                        color: AppColors.success, size: 14),
                    const SizedBox(width: 4),
                    const Text('Payment Verified',
                        style: TextStyle(
                            color: AppColors.success,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showDeleteOrderDialog(BuildContext context, OrderEntity order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete Order', style: TextStyle(color: Colors.white)),
        content: Text(
            'Are you sure you want to delete the order for "${order.serviceTitle}"?',
            style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              context.read<OrdersCubit>().deleteOrder(order.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(BuildContext context, OrderEntity order,
      String status, String label, IconData icon,
      {Color? color}) {
    final bool isCurrent = order.status == status;
    final bool isVerifyAction = status == 'approve_payment';

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton.icon(
        onPressed: isCurrent
            ? null
            : () {
                if (isVerifyAction) {
                  context.read<OrdersCubit>().approvePayment(order.id);
                } else {
                  context.read<OrdersCubit>().updateStatus(order.id, status);
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: isCurrent
              ? AppColors.primary
              : (color ?? Colors.white.withValues(alpha: 0.05)),
          foregroundColor: isCurrent ? Colors.black : (color ?? Colors.white70),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          minimumSize: const Size(0, 40), // Fix: Prevent infinite width crash in horizontal Row
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: Icon(icon, size: 16),
        label: Text(label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _PaymentsDashboard extends StatelessWidget {
  const _PaymentsDashboard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, pay_state.PaymentState>(
      builder: (context, state) {
        if (state is pay_state.PaymentLoading) return const Center(child: CircularProgressIndicator());
        if (state is pay_state.PaymentLoaded) {
          return Column(
            children: [
              _buildHeader(context, 'Payment Hub', 'Manage secure gateways.', () => _showPaymentDialog(context)),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: state.payments.length,
                  itemBuilder: (context, index) {
                    final method = state.payments[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: GlassPanel(
                        padding: 20,
                        child: Row(
                          children: [
                            const Icon(Icons.account_balance_rounded, color: AppColors.primary),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(method.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                  Text(method.accountNumber, style: const TextStyle(color: AppColors.textDisabled, fontSize: 13)),
                                ],
                              ),
                            ),
                            IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: () => _showPaymentDialog(context, method: method)),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: AppColors.surface,
                                    title: const Text('Delete Method', style: TextStyle(color: Colors.white)),
                                    content: const Text('Are you sure you want to remove this payment method?', style: TextStyle(color: AppColors.textSecondary)),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                        onPressed: () {
                                          context.read<PaymentCubit>().deletePaymentMethod(method.id);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
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
          );
        }
        return const Center(child: Text('Error loading payments.'));
      },
    );
  }
}

class _CustomerMessagesDashboard extends StatelessWidget {
  const _CustomerMessagesDashboard();

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    String adminId = "admin-id";
    if (authState is AuthAuthenticated) {
      adminId = authState.user.id;
    }

    // Only fetch once when screen is built
    context.read<InquiriesCubit>().fetchInquiries('', true);

    return BlocBuilder<InquiriesCubit, InquiriesState>(
      builder: (context, state) {
        if (state is InquiriesLoading) return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        if (state is InquiriesLoaded) {
          if (state.inquiries.isEmpty) {
            return const Center(child: Text('No customer inquiries yet.', style: TextStyle(color: Colors.white54)));
          }

          // Group by itemId to show conversation list (WhatsApp Style)
          final Map<String, List<InquiryEntity>> grouped = {};
          for (var inquiry in state.inquiries) {
            if (!grouped.containsKey(inquiry.itemId)) {
              grouped[inquiry.itemId] = [];
            }
            grouped[inquiry.itemId]!.add(inquiry);
          }

          final conversationKeys = grouped.keys.toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('Conversations', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: conversationKeys.length,
                  itemBuilder: (context, index) {
                    final itemId = conversationKeys[index];
                    final chatMessages = grouped[itemId]!;
                    final lastMessage = chatMessages.first; // Last because we ordered by desc in repo
                    
                    // Try to extract name from special format repository uses: "[[Name]]: message"
                    String displayName = 'Customer Chat';
                    String displayMessage = lastMessage.message;
                    
                    if (displayMessage.contains(']: ')) {
                      final parts = displayMessage.split(']: ');
                      displayName = parts[0].replaceFirst('[', '');
                      displayMessage = parts.sublist(1).join(']: ');
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: GlassPanel(
                        padding: 4,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InquiryChatScreen(
                                  itemId: itemId,
                                  itemTitle: displayName,
                                  userRole: 'admin',
                                  userId: adminId,
                                ),
                              ),
                            );
                          },
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                                child: Text(displayName[0].toUpperCase(), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.surface, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          title: Text(displayName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            displayMessage, 
                            maxLines: 1, 
                            overflow: TextOverflow.ellipsis, 
                            style: const TextStyle(color: AppColors.textDisabled, fontSize: 13),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${lastMessage.createdAt.hour}:${lastMessage.createdAt.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(color: AppColors.textDisabled, fontSize: 10),
                              ),
                              const SizedBox(height: 4),
                              const Icon(Icons.chevron_right, color: AppColors.textDisabled, size: 16),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Error loading messages.', style: TextStyle(color: Colors.redAccent)),
              TextButton(onPressed: () => context.read<InquiriesCubit>().fetchInquiries('', true), child: const Text('Retry')),
            ],
          ),
        );
      },
    );
  }
}

class _AdminProfileDashboard extends StatelessWidget {
  const _AdminProfileDashboard();

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    String email = 'admin@dynetix.com';
    if (authState is AuthAuthenticated) {
      email = authState.user.email;
    }

    // Fetch profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().fetchProfile(email);
    });

    return BlocBuilder<ProfileCubit, profile_state.ProfileState>(
      builder: (context, state) {
        String name = "Super Admin";
        String? imageUrl;
        
        if (state is profile_state.ProfileLoaded) {
          name = state.profile.name;
          imageUrl = state.profile.profileImageUrl;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.charcoalDepth,
                      child: ClipOval(
                        child: (imageUrl != null && imageUrl.isNotEmpty)
                            ? Image.network(
                                imageUrl,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                                },
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 120,
                                  height: 120,
                                  color: AppColors.cardBackground,
                                  child: const Icon(Icons.person_rounded, size: 60, color: AppColors.primary),
                                ),
                              )
                            : Container(
                                width: 120,
                                height: 120,
                                color: AppColors.cardBackground,
                                child: const Icon(Icons.person_rounded, size: 60, color: AppColors.primary),
                              ),
                      ),
                    ),
                    if (state is profile_state.ProfileLoaded)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: AppColors.primary,
                          radius: 18,
                          child: IconButton(
                            icon: const Icon(Icons.edit, size: 18, color: Colors.black),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(profile: state.profile),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(email, style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 48),
              _buildOption(
                context, 
                Icons.settings_outlined, 
                'System Settings',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SystemSettingsScreen())),
              ),
              _buildOption(
                context, 
                Icons.notifications_none_rounded, 
                'Notifications',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationSettingsScreen())),
              ),
              _buildOption(
                context, 
                Icons.palette_outlined, 
                'Theme Preferences',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ThemePreferencesScreen())),
              ),
              _buildOption(
                context, 
                Icons.info_outline_rounded, 
                'About Dynetix',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutDynetixScreen())),
              ),
              
              const SizedBox(height: 32),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Database Tools', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 16),
              DynetixButton(
                text: 'SEED INITIAL SERVICES',
                color: AppColors.primary.withValues(alpha: 0.1),
                textColor: AppColors.primary,
                isOutline: true,
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  );
                  try {
                    await ServicesRepositoryImpl().seedInitialData();
                    if (context.mounted) {
                      Navigator.pop(context); // Close loading
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Initial services seeded successfully!')));
                      context.read<ServicesCubit>().fetchServices();
                    }
                  } catch (e) {
                    if (context.mounted) {
                      Navigator.pop(context); // Close loading
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Seed failed: $e'), backgroundColor: Colors.redAccent));
                    }
                  }
                },
              ),
              const SizedBox(height: 12),
              DynetixButton(
                text: 'SEED PAYMENT METHODS',
                color: AppColors.primary.withValues(alpha: 0.1),
                textColor: AppColors.primary,
                isOutline: true,
                onPressed: () async {
                  await PaymentMethodsRepositoryImpl().seedInitialMethods();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment methods seeded successfully!')));
                    context.read<PaymentCubit>().fetchPaymentMethods();
                  }
                },
              ),

              const SizedBox(height: 40),
              DynetixButton(
                text: 'LOGOUT',
                color: Colors.redAccent.withValues(alpha: 0.1),
                textColor: Colors.redAccent,
                isOutline: true,
                onPressed: () {
                  context.read<AuthCubit>().logout();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const RoleSelectionScreen()), (route) => false);
                }
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String title, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassPanel(
        padding: 0,
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            onTap: onTap,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            leading: Icon(icon, color: AppColors.primary),
            title: Text(title, style: const TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textDisabled),
          ),
        ),
      ),
    );
  }
}

// --- Shared Helper Widgets ---

Widget _buildHeader(BuildContext context, String title, String subtitle, VoidCallback onAdd) {
  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
        IconButton(
          onPressed: onAdd,
          style: IconButton.styleFrom(backgroundColor: AppColors.primary.withValues(alpha: 0.1)),
          icon: const Icon(Icons.add_rounded, color: AppColors.primary),
        ),
      ],
    ),
  );
}

Widget _buildAdminItemCard({required String title, required String price, String type = 'service', required VoidCallback onEdit, required VoidCallback onDelete}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    child: GlassPanel(
      padding: 16,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(_getServiceIcon(title, type), color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                Text(price, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent, size: 20), onPressed: onEdit),
          IconButton(icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20), onPressed: onDelete),
        ],
      ),
    ),
  );
}

void _showServiceDialog(BuildContext context, {ServiceEntity? service, String type = 'service'}) {
  final titleController = TextEditingController(text: service?.title ?? '');
  final priceController = TextEditingController(text: service?.price.toString() ?? '');
  final descController = TextEditingController(text: service?.description ?? '');

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(service == null ? 'Add $type' : 'Edit $type', style: const TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 16),
            TextField(controller: priceController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            TextField(controller: descController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final newService = ServiceEntity(
              id: service?.id ?? '',
              title: titleController.text,
              price: double.tryParse(priceController.text) ?? 0.0,
              description: descController.text,
              category: 'General',
              type: type,
            );
            if (service == null) {
              context.read<ServicesCubit>().addService(newService);
            } else {
              context.read<ServicesCubit>().updateService(newService);
            }
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

void _showPaymentDialog(BuildContext context, {PaymentMethodEntity? method}) {
  final nameController = TextEditingController(text: method?.name ?? '');
  final numberController = TextEditingController(text: method?.accountNumber ?? '');
  final titleController = TextEditingController(text: method?.accountTitle ?? '');

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text('Payment Method', style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Provider Name (e.g. EasyPaisa)')),
            const SizedBox(height: 16),
            TextField(controller: numberController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Account Number')),
            const SizedBox(height: 16),
            TextField(controller: titleController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Account Title (Owner Name)')),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final newMethod = PaymentMethodEntity(
              id: method?.id ?? '',
              name: nameController.text,
              accountNumber: numberController.text,
              accountTitle: titleController.text,
            );
            if (method == null) {
              context.read<PaymentCubit>().addPaymentMethod(newMethod);
            } else {
              context.read<PaymentCubit>().updatePaymentMethod(newMethod);
            }
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
