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
import '../../../inquiries/presentation/bloc/inquiries_cubit.dart';
import '../../../inquiries/presentation/bloc/inquiries_state.dart';
import '../../../inquiries/domain/entities/inquiry_entity.dart';
import '../../../inquiries/presentation/screens/inquiry_chat_screen.dart';
import '../../../orders/presentation/bloc/orders_cubit.dart';
import '../../../orders/presentation/bloc/orders_state.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../reviews/presentation/bloc/reviews_cubit.dart';
import '../../../reviews/domain/entities/review_entity.dart';
import '../../../profile/presentation/bloc/profile_cubit.dart';
import '../../../profile/presentation/bloc/profile_state.dart' as profile_state;
import '../../../profile/presentation/screens/profile_screen.dart';
import 'package:dynetix_app/features/support/presentation/screens/ai_assistant_screen.dart';

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
      _CustomerMessagesTab(userId: authState is AuthAuthenticated ? authState.user.id : ''),
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
          IconButton(onPressed: () {
            setState(() => _currentIndex = 3); // Switch to Chat tab
          }, icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary)),
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
        selectedFontSize: 9, // Small font to fit 7 items
        unselectedFontSize: 9,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.school_rounded), label: 'Academy'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_rounded), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_rounded), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Payments'),
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
                    child: Icon(Icons.psychology_rounded, size: 160, color: Colors.white.withValues(alpha: 0.2)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Meet your Dynetix\nAI Assistant', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1.2)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AiAssistantScreen())),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue.shade900,
                          minimumSize: const Size(120, 40),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Ask Now', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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

class _CustomerMessagesTab extends StatelessWidget {
  final String userId;
  const _CustomerMessagesTab({required this.userId});

  @override
  Widget build(BuildContext context) {
    if (userId.isEmpty) return const Center(child: Text('Please login to see messages.', style: TextStyle(color: Colors.white54)));

    // Fetch inquiries for this customer
    context.read<InquiriesCubit>().fetchInquiries(userId, false);

    return BlocBuilder<InquiriesCubit, InquiriesState>(
      builder: (context, state) {
        if (state is InquiriesLoading) return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        
        if (state is InquiriesLoaded) {
          if (state.inquiries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline_rounded, size: 64, color: AppColors.textDisabled),
                  const SizedBox(height: 16),
                  const Text('No conversations yet.', style: TextStyle(color: AppColors.textSecondary)),
                  const Text('Message us from any service or course!', style: TextStyle(color: AppColors.textDisabled, fontSize: 12)),
                ],
              ),
            );
          }

          // Group by itemId
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
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('My Messages', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    IconButton(
                      icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
                      onPressed: () => _showClearAllChatsDialog(context, conversationKeys),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: conversationKeys.length,
                  itemBuilder: (context, index) {
                    final itemId = conversationKeys[index];
                    final chatMessages = grouped[itemId]!;
                    final lastMessage = chatMessages.first;
                    
                    String displayMessage = lastMessage.message;
                    // If message contains image blob URL
                    if (displayMessage.contains('blob:http')) {
                      displayMessage = 'Sent an attachment 📎';
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
                                  itemTitle: 'Support Chat', // In customer view, it's chat with admin
                                  userRole: 'customer',
                                  userId: userId,
                                ),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            child: const Icon(Icons.headset_mic_rounded, color: AppColors.primary),
                          ),
                          title: const Text('Dynetix Support', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            displayMessage, 
                            maxLines: 1, 
                            overflow: TextOverflow.ellipsis, 
                            style: const TextStyle(color: AppColors.textDisabled, fontSize: 13),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${lastMessage.createdAt.hour}:${lastMessage.createdAt.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(color: AppColors.textDisabled, fontSize: 10),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 18),
                                onPressed: () => _showDeleteChatDialog(context, itemId),
                              ),
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
        return const Center(child: Text('Error loading messages.', style: TextStyle(color: Colors.redAccent)));
      },
    );
  }

  void _showDeleteChatDialog(BuildContext context, String itemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete Chat', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this conversation?', style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              context.read<InquiriesCubit>().clearChat(itemId, userId: userId, role: 'customer');
              Navigator.pop(context);
              context.read<InquiriesCubit>().fetchInquiries(userId, false);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showClearAllChatsDialog(BuildContext context, List<String> itemIds) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Clear All Chats', style: TextStyle(color: Colors.white)),
        content: const Text('This will permanently delete all your conversations. Proceed?', style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.pop(context);
              for (var id in itemIds) {
                await context.read<InquiriesCubit>().clearChat(id, userId: userId, role: 'customer');
              }
              if (context.mounted) {
                context.read<InquiriesCubit>().fetchInquiries(userId, false);
              }
            },
            child: const Text('Clear All'),
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
                                Row(
                                  children: [
                                    _buildStatusBadge(order.status),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 18),
                                      onPressed: () => _showDeleteOrderDialog(context, order),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
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
                              // Payment proof button removed per user request
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
        // Use a generic dynamic way to avoid dart:io on web
        fileToUpload = image; // Pass XFile directly
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

  void _showDeleteOrderDialog(BuildContext context, OrderEntity order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete Project', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to delete the project "${order.serviceTitle}"? This action cannot be undone.',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              await context.read<OrdersCubit>().deleteOrder(order.id);
              if (context.mounted) {
                // Customer only hides/clears for themselves
                await context.read<InquiriesCubit>().clearChat('global_support', userId: userId, role: 'customer');
                Navigator.pop(context);
                // Refresh list
                context.read<OrdersCubit>().watchCustomerOrders(userId);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order canceled and chat cleared'), backgroundColor: AppColors.error),
                );
              }
            },
            child: const Text('Delete'),
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

  final bool hasDiscount = item.discountPrice != null && item.discountPrice! < item.price;
  final double displayPrice = hasDiscount ? item.discountPrice! : item.price;
  final int offPercentage = hasDiscount ? (((item.price - item.discountPrice!) / item.price) * 100).round() : 0;

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    child: Stack(
      children: [
        GlassPanel(
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
                            ...List.generate(5, (index) => Icon(
                              index < item.averageRating.floor() ? Icons.star_rounded : Icons.star_half_rounded, 
                              color: AppColors.gold, 
                              size: 14
                            )),
                            const SizedBox(width: 6),
                            Text(
                              '${item.averageRating.toStringAsFixed(1)} (${item.totalReviews})', 
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Rs. ${displayPrice.toStringAsFixed(0)}', 
                                      style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 18)
                                    ),
                                  ],
                                ),
                                if (hasDiscount)
                                  Text(
                                    'Rs. ${item.price.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: AppColors.textDisabled, 
                                      fontSize: 13, 
                                      decoration: TextDecoration.lineThrough,
                                      height: 1.0,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (item.portfolioUrls.isNotEmpty) ...[
                const SizedBox(height: 16),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: item.portfolioUrls.length,
                    itemBuilder: (context, i) => Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(image: NetworkImage(item.portfolioUrls[i]), fit: BoxFit.cover),
                        border: Border.all(color: Colors.white10),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Text(item.description, style: const TextStyle(color: AppColors.textDisabled, fontSize: 12)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: DynetixButton(
                      text: 'BOOK NOW',
                      onPressed: () => _showCheckoutDialog(context, item, displayPrice),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DynetixButton(
                      text: 'MESSAGE',
                      isOutline: true,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => InquiryChatScreen(
                          itemId: 'global_support',
                          itemTitle: 'Dynetix Support',
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
        if (hasDiscount)
          Positioned(
            top: 0,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('FLAT', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  Text('$offPercentage%', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, height: 1.1)),
                  const Text('OFF', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}

void _showCheckoutDialog(BuildContext context, ServiceEntity item, double basePrice) {
  final authState = context.read<AuthCubit>().state;
  final promoController = TextEditingController();
  double finalPrice = basePrice;
  int discountPercent = 0;
  bool isVerifying = false;

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Checkout Summary', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textDisabled, fontSize: 11)),
            const Divider(height: 32, color: Colors.white10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Service Price', style: TextStyle(color: Colors.white70)),
                Text('Rs. ${basePrice.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            if (discountPercent > 0) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Promo Discount ($discountPercent%)', style: const TextStyle(color: Colors.greenAccent)),
                  Text('-Rs. ${(basePrice * discountPercent / 100).toStringAsFixed(0)}', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: promoController,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Enter Promo Code',
                suffixIcon: IconButton(
                  icon: isVerifying ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.check_circle_outline, color: AppColors.primary),
                  onPressed: () {
                    setDialogState(() => isVerifying = true);
                    // Simple Mock Verification for Presentation
                    Future.delayed(const Duration(seconds: 1), () {
                      if (context.mounted) {
                        setDialogState(() {
                          isVerifying = false;
                          if (promoController.text.toUpperCase() == 'DYNETIX10') {
                            discountPercent = 10;
                            finalPrice = basePrice * 0.9;
                          } else if (promoController.text.toUpperCase() == 'ELITE20') {
                            discountPercent = 20;
                            finalPrice = basePrice * 0.8;
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Promo Code')));
                          }
                        });
                      }
                    });
                  },
                ),
              ),
            ),
            const Divider(height: 32, color: Colors.white10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TOTAL PAYABLE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('Rs. ${finalPrice.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 22)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              String userId = "";
              if (authState is AuthAuthenticated) userId = authState.user.id;

              if (userId.isEmpty || userId == 'anonymous') {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please login first')));
                return;
              }

              final order = OrderEntity(
                id: '', 
                customerId: userId,
                serviceId: item.id,
                serviceTitle: item.title,
                price: finalPrice,
                status: 'pending',
                createdAt: DateTime.now(),
              );
              
              await context.read<OrdersCubit>().createOrder(order);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order placed successfully!'), backgroundColor: AppColors.success),
                );
              }
            },
            child: const Text('CONFIRM ORDER'),
          ),
        ],
      ),
    ),
  );
}
