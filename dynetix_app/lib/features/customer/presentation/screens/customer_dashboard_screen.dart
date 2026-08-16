import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dynetix_widgets.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../services/presentation/bloc/services_cubit.dart';
import '../../../services/presentation/bloc/services_state.dart';
import '../../../services/domain/entities/service_entity.dart';
import '../../../payments/presentation/bloc/payment_cubit.dart';
import '../../../payments/presentation/bloc/payment_state.dart' as pay_state;
import '../../../inquiries/presentation/screens/inquiry_chat_screen.dart';
import '../../../orders/presentation/bloc/orders_cubit.dart';
import '../../../orders/presentation/bloc/orders_state.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../reviews/presentation/bloc/reviews_cubit.dart';
import '../../../reviews/domain/entities/review_entity.dart';
import '../../../profile/presentation/bloc/profile_cubit.dart';
import '../../../profile/presentation/bloc/profile_state.dart' as profile_state;
import '../../../profile/presentation/screens/profile_screen.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  State<CustomerDashboardScreen> createState() => _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  int _currentIndex = 0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ServicesCubit>().fetchServices();
    context.read<PaymentCubit>().fetchPaymentMethods();

    // Fetch profile early so it's available for the Home tab avatar
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.read<ProfileCubit>().fetchProfile(authState.user.email);
    }
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
      _CustomerHomeTab(
        userName: userName,
        onExplore: () => setState(() => _currentIndex = 1),
        onSearch: (query) {
          setState(() {
            _searchQuery = query;
            _currentIndex = 1;
          });
        },
      ),
      _CustomerServicesTab(searchQuery: _searchQuery),
      _CustomerAcademyTab(searchQuery: _searchQuery),
      _CustomerProjectsTab(userId: authState is AuthAuthenticated ? authState.user.id : ''),
      const _CustomerPaymentsTab(),
      ProfileScreen(userEmail: userEmail, showAppBar: false),
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
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            // Clear search when switching tabs manually
            if (index != 1 && index != 2) {
              _searchQuery = '';
            }
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.school_rounded), label: 'Academy'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_rounded), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Assets'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}

class _CustomerHomeTab extends StatefulWidget {
  final String userName;
  final VoidCallback onExplore;
  final Function(String) onSearch;
  const _CustomerHomeTab({required this.userName, required this.onExplore, required this.onSearch});

  @override
  State<_CustomerHomeTab> createState() => _CustomerHomeTabState();
}

class _CustomerHomeTabState extends State<_CustomerHomeTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello, ${widget.userName}! 👋',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        overflow: TextOverflow.ellipsis),
                    const Text('What would you like to learn or explore today?',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              BlocBuilder<ProfileCubit, profile_state.ProfileState>(
                builder: (context, state) {
                  String? imageUrl;
                  if (state is profile_state.ProfileLoaded) {
                    imageUrl = state.profile.profileImageUrl;
                  }
                  return CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.cardBackground,
                    child: ClipOval(
                      child: (imageUrl != null && imageUrl.isNotEmpty)
                          ? Image.network(
                              imageUrl,
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person_rounded,
                                      color: AppColors.primary),
                            )
                          : const Icon(Icons.person_rounded,
                              color: AppColors.primary),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Search Bar
          TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search services or courses...',
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onSubmitted: (value) {
              widget.onSearch(value);
            },
          ),
          const SizedBox(height: 24),

          // Banner
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.7),
                  AppColors.primary.withValues(alpha: 0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: 0,
                  child: Opacity(
                    opacity: 0.8,
                    child: Icon(Icons.laptop_chromebook, size: 160, color: Colors.white.withValues(alpha: 0.2)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Empowering You with\nSkills for Tomorrow', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1.2)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: widget.onExplore,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue.shade900,
                          minimumSize: const Size(120, 40),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Explore Now', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Categories
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Top Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              TextButton(onPressed: () => context.read<ServicesCubit>().fetchServices(), child: const Text('Refresh')),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<ServicesCubit, ServicesState>(
            builder: (context, state) {
              if (state is ServicesLoaded && state.services.isNotEmpty) {
                final topServices = state.services.take(6).toList(); // Show more if available
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: topServices.map((s) => Padding(
                      padding: const EdgeInsets.only(right: 8), // Minimal spacing
                      child: GestureDetector(
                        onTap: () => widget.onSearch(s.title),
                        child: _buildCategoryItem(_getServiceIcon(s.title, s.type), s.title, AppColors.primary),
                      ),
                    )).toList(),
                  ),
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => widget.onSearch('Web Design'),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildCategoryItem(Icons.code, 'Web Design', Colors.blue),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => widget.onSearch('UI/UX Design'),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildCategoryItem(Icons.layers, 'UI/UX Design', Colors.purple),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => widget.onSearch('Cloud Computing'),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildCategoryItem(Icons.cloud, 'Cloud Computing', Colors.orange),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => widget.onSearch('Digital Marketing'),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildCategoryItem(Icons.campaign, 'Digital Marketing', Colors.green),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          const Text('Popular Courses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          // Placeholder for courses
          const Text('Check the Academy tab for all courses.', style: TextStyle(color: AppColors.textDisabled, fontSize: 13)),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label, Color color) {
    return SizedBox(
      width: 85, // Constrained width for consistent alignment
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label, 
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w500), 
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _CustomerServicesTab extends StatelessWidget {
  final String searchQuery;
  const _CustomerServicesTab({this.searchQuery = ''});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        if (state is ServicesLoading) return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        if (state is ServicesError) return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.redAccent)));

        if (state is ServicesLoaded) {
          final services = state.services.where((s) {
            final matchesType = s.type == 'service';
            final matchesSearch = s.title.toLowerCase().contains(searchQuery.toLowerCase()) || 
                                 s.description.toLowerCase().contains(searchQuery.toLowerCase());
            return matchesType && matchesSearch;
          }).toList();

          if (services.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off_rounded, size: 64, color: AppColors.textDisabled),
                  const SizedBox(height: 16),
                  Text(searchQuery.isEmpty ? 'No services available.' : 'No services found for "$searchQuery"', 
                    style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<ServicesCubit>().fetchServices(),
            color: AppColors.primary,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
              itemCount: services.length,
              itemBuilder: (context, index) => _buildConsumerCard(context, services[index]),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _CustomerAcademyTab extends StatelessWidget {
  final String searchQuery;
  const _CustomerAcademyTab({this.searchQuery = ''});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        if (state is ServicesLoading) return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        if (state is ServicesError) return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.redAccent)));

        if (state is ServicesLoaded) {
          final courses = state.services.where((s) {
            final matchesType = s.type == 'course';
            final matchesSearch = s.title.toLowerCase().contains(searchQuery.toLowerCase()) || 
                                 s.description.toLowerCase().contains(searchQuery.toLowerCase());
            return matchesType && matchesSearch;
          }).toList();

          if (courses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off_rounded, size: 64, color: AppColors.textDisabled),
                  const SizedBox(height: 16),
                  Text(searchQuery.isEmpty ? 'No courses available.' : 'No courses found for "$searchQuery"', 
                    style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<ServicesCubit>().fetchServices(),
            color: AppColors.primary,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
              itemCount: courses.length,
              itemBuilder: (context, index) => _buildConsumerCard(context, courses[index]),
            ),
          );
        }
        return const SizedBox();
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
                                    if (method.accountTitle != null && method.accountTitle!.isNotEmpty)
                                      Text(method.accountTitle!, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500)),
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

class _CustomerProjectsTab extends StatelessWidget {
  final String userId;
  const _CustomerProjectsTab({required this.userId});

  @override
  Widget build(BuildContext context) {
    if (userId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<OrdersCubit>().watchCustomerOrders(userId);
      });
    }

    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading) return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        
        if (state is OrdersError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.redAccent),
                const SizedBox(height: 16),
                const Text('Realtime connection timed out.', style: TextStyle(color: Colors.white)),
                Text('Error: ${state.message}', style: const TextStyle(color: AppColors.textDisabled, fontSize: 10), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                DynetixButton(
                  text: 'RETRY CONNECTION',
                  isOutline: true,
                  onPressed: () {
                    if (userId.isNotEmpty) {
                      context.read<OrdersCubit>().watchCustomerOrders(userId);
                    }
                  },
                ),
              ],
            ),
          );
        }

        if (state is OrdersLoaded) {
          if (state.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_late_outlined, size: 64, color: AppColors.textDisabled.withValues(alpha: 0.2)),
                  const SizedBox(height: 16),
                  const Text('No active projects yet.', style: TextStyle(color: AppColors.textDisabled)),
                  const Text('Book a service to get started!', style: TextStyle(color: AppColors.textDisabled, fontSize: 12)),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('My Active Projects', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
                      onPressed: () => context.read<OrdersCubit>().watchCustomerOrders(userId),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: state.orders.length,
                  itemBuilder: (context, index) {
                    final order = state.orders[index];
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
                                Expanded(child: Text(order.serviceTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                                _buildStatusBadge(order.status),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text('Order ID: ${order.id.substring(0, 8)}', style: const TextStyle(color: AppColors.textDisabled, fontSize: 11)),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Rs. ${order.price.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                Text('Created: ${order.createdAt.day}/${order.createdAt.month}', style: const TextStyle(color: AppColors.textDisabled, fontSize: 11)),
                              ],
                            ),
                            if (order.status == 'completed') ...[
                              const SizedBox(height: 20),
                              DynetixButton(
                                text: 'GIVE REVIEW',
                                color: AppColors.gold,
                                textColor: Colors.black,
                                onPressed: () => _showRatingDialog(context, order),
                              ),
                            ],
                            if (order.paymentStatus == 'unpaid') ...[
                              const SizedBox(height: 20),
                              DynetixButton(
                                text: 'PAY NOW',
                                color: AppColors.primary,
                                textColor: Colors.black,
                                onPressed: () => _showPaymentInstructions(context, order),
                              ),
                            ] else if (order.paymentStatus == 'pending_verification') ...[
                              const SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.orangeAccent.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.3)),
                                ),
                                child: const Center(
                                  child: Text('VERIFICATION PENDING', style: TextStyle(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
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
        return const Center(child: Text('Please login to view projects.'));
      },
    );
  }

  Future<void> _pickPaymentProof(BuildContext context, String orderId) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uploading proof...')));
      
      dynamic fileToUpload;
      if (kIsWeb) {
        fileToUpload = await image.readAsBytes();
      } else {
        fileToUpload = File(image.path);
      }
      
      await context.read<OrdersCubit>().uploadPaymentProof(orderId, fileToUpload);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment proof uploaded for verification!'), backgroundColor: AppColors.success));
    }
  }

  void _showPaymentInstructions(BuildContext context, OrderEntity order) {
    final paymentState = context.read<PaymentCubit>().state;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Secure Payment', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView( // Fix: Wrap with SingleChildScrollView to prevent overflow
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Transfer the exact amount to one of our accounts:', style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 12),
                Text('Rs. ${order.price.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.primary, fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                if (paymentState is pay_state.PaymentLoaded && paymentState.payments.isNotEmpty)
                  ...paymentState.payments.map((p) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                              Text(p.accountNumber, style: const TextStyle(color: AppColors.textDisabled, fontSize: 12)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.primary),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: p.accountNumber));
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account number copied!')));
                          },
                        ),
                      ],
                    ),
                  )).toList()
                else
                  const Text('No payment methods found. Please contact support.', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                const SizedBox(height: 16),
                const Text('After payment, click the button below to upload your screenshot.', style: TextStyle(color: AppColors.textDisabled, fontSize: 11), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _pickPaymentProof(context, order.id);
            },
            child: const Text('I HAVE PAID (Upload Proof)'),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context, OrderEntity order) {
    int selectedRating = 5;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Rate our Service', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(order.serviceTitle, style: const TextStyle(color: AppColors.primary, fontSize: 14)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: AppColors.gold,
                      size: 32,
                    ),
                    onPressed: () => setDialogState(() => selectedRating = index + 1),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Share your experience...',
                  hintStyle: const TextStyle(color: Colors.white24),
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final review = ReviewEntity(
                  id: '',
                  orderId: order.id,
                  serviceId: order.serviceId ?? '0',
                  customerId: order.customerId,
                  rating: selectedRating,
                  comment: commentController.text.trim(),
                  createdAt: DateTime.now(),
                );
                context.read<ReviewsCubit>().submitReview(review);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thank you for your feedback!'), backgroundColor: AppColors.success),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'completed': color = AppColors.success; break;
      case 'in_progress': color = Colors.blueAccent; break;
      case 'review': color = Colors.orangeAccent; break;
      default: color = AppColors.textDisabled;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}

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
  return Icons.miscellaneous_services_rounded;
}

Widget _buildConsumerCard(BuildContext context, ServiceEntity item) {
  final authState = context.read<AuthCubit>().state;
  String userId = "";
  if (authState is AuthAuthenticated) {
    userId = authState.user.id;
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    child: GlassPanel(
      padding: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(_getServiceIcon(item.title, item.type), color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (index) => const Icon(Icons.star_rounded, color: AppColors.gold, size: 14)),
                        const SizedBox(width: 6),
                        const Text('5.0', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        const Spacer(),
                        Text('Rs. ${item.price.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(item.description, style: const TextStyle(color: AppColors.textDisabled, fontSize: 12)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: DynetixButton(
                  text: 'BOOK NOW',
                  onPressed: () async {
                    if (userId.isEmpty || userId == 'anonymous') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please login to book a service.'), backgroundColor: Colors.orangeAccent),
                      );
                      return;
                    }
                    
                    final order = OrderEntity(
                      id: '', 
                      customerId: userId,
                      serviceId: item.id,
                      serviceTitle: item.title,
                      price: item.price,
                      status: 'pending',
                      createdAt: DateTime.now(),
                    );
                    
                    await context.read<OrdersCubit>().createOrder(order);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order request sent! Track it in Projects tab.'), backgroundColor: AppColors.success),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DynetixButton(
                  text: 'MESSAGE',
                  isOutline: true,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => InquiryChatScreen(
                      itemId: item.id, 
                      itemTitle: item.title, 
                      userRole: 'customer', 
                      userId: userId
                    )));
                  },
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
