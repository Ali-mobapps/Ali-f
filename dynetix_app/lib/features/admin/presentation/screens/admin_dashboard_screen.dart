import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/vip_theme.dart';
import '../../../../core/widgets/dynetix_widgets.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const _ServicesDashboard(),
      const _AcademyDashboard(),
      const _PaymentsDashboard(),
      const _CustomerMessagesDashboard(),
      const _AdminProfileDashboard(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('DYNETIX ADMIN', style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex >= 5 ? 0 : _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textDisabled,
        backgroundColor: AppColors.surface,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.school_rounded), label: 'Academy'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Payments'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
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
        if (state is ServicesLoading) return const Center(child: CircularProgressIndicator());
        if (state is ServicesLoaded) {
          final services = state.services.where((s) => s.type == 'service').toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, 'Core Services', 'Manage digital solutions.', () => _showServiceDialog(context, type: 'service')),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final item = services[index];
                    return _buildAdminItemCard(
                      title: item.title,
                      price: '\$${item.price.toStringAsFixed(2)}',
                      onEdit: () => _showServiceDialog(context, service: item),
                      onDelete: () => context.read<ServicesCubit>().deleteService(item.id),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const Center(child: Text('No services found.'));
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
        if (state is ServicesLoading) return const Center(child: CircularProgressIndicator());
        if (state is ServicesLoaded) {
          final courses = state.services.where((s) => s.type == 'course').toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, 'Academy Suite', 'Manage premium curricula.', () => _showServiceDialog(context, type: 'course')),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final item = courses[index];
                    return _buildAdminItemCard(
                      title: item.title,
                      price: '\$${item.price.toStringAsFixed(2)}',
                      isCourse: true,
                      onEdit: () => _showServiceDialog(context, service: item),
                      onDelete: () => context.read<ServicesCubit>().deleteService(item.id),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const Center(child: Text('No courses found.'));
      },
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InquiriesCubit>().fetchInquiries('', true);
    });

    return BlocBuilder<InquiriesCubit, InquiriesState>(
      builder: (context, state) {
        if (state is InquiriesLoading) return const Center(child: CircularProgressIndicator());
        if (state is InquiriesLoaded) {
          if (state.inquiries.isEmpty) {
            return const Center(child: Text('No customer inquiries yet.', style: TextStyle(color: Colors.white54)));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('Customer Inquiries', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: state.inquiries.length,
                  itemBuilder: (context, index) {
                    final inquiry = state.inquiries[index];
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
                                  itemId: inquiry.itemId,
                                  itemTitle: 'Customer Inquiry',
                                  userRole: 'admin',
                                  userId: 'admin-id',
                                ),
                              ),
                            );
                          },
                          leading: const CircleAvatar(
                            backgroundColor: Colors.white10,
                            child: Icon(Icons.person_rounded, color: AppColors.primary),
                          ),
                          title: Text(inquiry.message, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          subtitle: Text('User ID: ${inquiry.userId}', style: const TextStyle(color: AppColors.textDisabled, fontSize: 11)),
                          trailing: const Icon(Icons.chevron_right, color: AppColors.textDisabled),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const Center(child: Text('Error loading messages.'));
      },
    );
  }
}

class _AdminProfileDashboard extends StatelessWidget {
  const _AdminProfileDashboard();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Center(
            child: CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.surface,
              child: Icon(Icons.person, size: 80, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Super Admin', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const Text('admin@dynetix.com', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 48),
          _buildOption(Icons.settings_outlined, 'System Settings'),
          _buildOption(Icons.notifications_none_rounded, 'Notifications'),
          _buildOption(Icons.palette_outlined, 'Theme Preferences'),
          _buildOption(Icons.info_outline_rounded, 'About Dynetix'),
          
          const SizedBox(height: 32),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Database Tools', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(height: 16),
          DynetixButton(
            text: 'SEED INITIAL SERVICES',
            color: AppColors.primary.withOpacity(0.1),
            textColor: AppColors.primary,
            isOutline: true,
            onPressed: () async {
              await ServicesRepositoryImpl().seedInitialData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Initial services seeded successfully!')));
                context.read<ServicesCubit>().fetchServices();
              }
            },
          ),
          const SizedBox(height: 12),
          DynetixButton(
            text: 'SEED PAYMENT METHODS',
            color: AppColors.primary.withOpacity(0.1),
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
            color: Colors.redAccent.withOpacity(0.1),
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
  }

  Widget _buildOption(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassPanel(
        padding: 4,
        child: ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textDisabled),
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
          style: IconButton.styleFrom(backgroundColor: AppColors.primary.withOpacity(0.1)),
          icon: const Icon(Icons.add_rounded, color: AppColors.primary),
        ),
      ],
    ),
  );
}

Widget _buildAdminItemCard({required String title, required String price, bool isCourse = false, required VoidCallback onEdit, required VoidCallback onDelete}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    child: GlassPanel(
      padding: 16,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(isCourse ? Icons.school_rounded : Icons.design_services_rounded, color: AppColors.primary, size: 20),
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

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text('Payment Method', style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: nameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Provider Name')),
          const SizedBox(height: 16),
          TextField(controller: numberController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Account Number')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final newMethod = PaymentMethodEntity(
              id: method?.id ?? '',
              name: nameController.text,
              accountNumber: numberController.text,
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
