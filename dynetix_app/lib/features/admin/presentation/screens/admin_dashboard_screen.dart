import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/admin_cubit.dart';
import '../../data/models/service_item_model.dart';
import '../../../payments/data/models/payment_method_model.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0F111A), // Dark VIP theme
        body: SafeArea(
          child: BlocBuilder<AdminCubit, AdminState>(
            builder: (context, state) {
              if (state is AdminLoading) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF00E676)));
              }
              if (state is AdminLoaded) {
                final pages = [
                  _buildServicesTab(context, state.services, isAcademy: false),
                  _buildServicesTab(context, state.academyCourses, isAcademy: true),
                  _buildPaymentMethodsTab(context, state.paymentMethods),
                  _buildAdminProfileTab(context),
                ];
                return pages[_currentIndex];
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: const Color(0xFF161925),
          selectedItemColor: const Color(0xFF00E676), // Neon Green
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.category_rounded), label: 'Services'),
            BottomNavigationBarItem(icon: Icon(Icons.school_rounded), label: 'Academy'),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Payments'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  // --- 1. SERVICES & ACADEMY DASHBOARD BUILDER ---
  Widget _buildServicesTab(BuildContext context, List<ServiceItemModel> items, {required bool isAcademy}) {
    return Column(
      children: [
        _buildHeader(
          title: isAcademy ? 'Welcome to Academy' : 'Welcome to Dynetix',
          subtitle: isAcademy ? 'Manage courses, pricing & visibility' : 'Manage core client services',
          onAddPressed: () => _showAddEditServiceDialog(context, isAcademy: isAcademy),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2235),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF00E676).withOpacity(0.15),
                    child: Icon(
                      isAcademy ? Icons.school : Icons.design_services,
                      color: const Color(0xFF00E676),
                    ),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.w600),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_rounded, color: Colors.blueAccent),
                        onPressed: () => _showAddEditServiceDialog(context, item: item, isAcademy: isAcademy),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_rounded, color: Colors.redAccent),
                        onPressed: () => context.read<AdminCubit>().deleteService(item.id, isAcademy: isAcademy),
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

  // --- 2. PAYMENT METHODS DASHBOARD BUILDER ---
  Widget _buildPaymentMethodsTab(BuildContext context, List<PaymentMethodModel> methods) {
    return Column(
      children: [
        _buildHeader(
          title: 'Payment Gateway Setup',
          subtitle: 'Manage payment accounts & 1-Tap Copy setup',
          onAddPressed: () => _showAddEditPaymentDialog(context),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: methods.length,
            itemBuilder: (context, index) {
              final method = methods[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2235),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF00E676).withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.account_balance_rounded, color: Color(0xFF00E676), size: 28),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(method.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              if (method.accountTitle != null)
                                Text(method.accountTitle!, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () => _showAddEditPaymentDialog(context, method: method),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white10, height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          method.accountNumber,
                          style: const TextStyle(color: Color(0xFFFFD700), fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00E676),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: method.accountNumber));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${method.name} Number Copied!')),
                            );
                          },
                          icon: const Icon(Icons.copy_rounded, size: 16),
                          label: const Text('Copy', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- 3. ADMIN PROFILE DASHBOARD ---
  Widget _buildAdminProfileTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF00E676),
                  child: CircleAvatar(
                    radius: 47,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/300?img=12'),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Color(0xFF00E676), shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt, color: Colors.black, size: 18),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text('Dynetix Admin', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const Text('admin@dynetix.com', style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 24),
          _buildProfileOption(Icons.edit_rounded, 'Edit Profile', () {}),
          _buildProfileOption(Icons.settings_rounded, 'App Settings', () {}),
          _buildProfileOption(Icons.notifications_active_rounded, 'Notifications', () {}),
          _buildProfileOption(Icons.palette_rounded, 'Theme Preferences', () {}),
          _buildProfileOption(Icons.info_outline_rounded, 'About Dynetix', () {}),
          _buildProfileOption(Icons.system_update_rounded, 'Check for Updates', () {}),
          const SizedBox(height: 16),
          _buildProfileOption(
            Icons.logout_rounded,
            'Logout',
                () => Navigator.of(context).pop(),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  // Helper Widgets & Dialogs
  Widget _buildHeader({required String title, required String subtitle, required VoidCallback onAddPressed}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          IconButton(
            style: IconButton.styleFrom(backgroundColor: const Color(0xFF00E676)),
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: onAddPressed,
          )
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: const Color(0xFF1E2235), borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? Colors.redAccent : const Color(0xFF00E676)),
        title: Text(title, style: TextStyle(color: isDestructive ? Colors.redAccent : Colors.white, fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showAddEditServiceDialog(BuildContext context, {ServiceItemModel? item, required bool isAcademy}) {
    final titleController = TextEditingController(text: item?.title ?? '');
    final priceController = TextEditingController(text: item?.price.toString() ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF161925),
        title: Text(item == null ? 'Add Item' : 'Edit Item', style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Title', labelStyle: TextStyle(color: Colors.grey)),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Price (\$)', labelStyle: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)),
            onPressed: () {
              final newTitle = titleController.text;
              final newPrice = double.tryParse(priceController.text) ?? 0.0;
              if (item == null) {
                context.read<AdminCubit>().addService(
                  ServiceItemModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: newTitle,
                    price: newPrice,
                    isAcademyCourse: isAcademy,
                  ),
                  isAcademy: isAcademy,
                );
              } else {
                context.read<AdminCubit>().updateService(
                  item.copyWith(title: newTitle, price: newPrice),
                  isAcademy: isAcademy,
                );
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('Save', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showAddEditPaymentDialog(BuildContext context, {PaymentMethodModel? method}) {
    final titleController = TextEditingController(text: method?.name ?? '');
    final numberController = TextEditingController(text: method?.accountNumber ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF161925),
        title: Text(method == null ? 'Add Payment Gateway' : 'Edit Gateway', style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Provider Name (e.g. Easypaisa)', labelStyle: TextStyle(color: Colors.grey)),
            ),
            TextField(
              controller: numberController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Account Number', labelStyle: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)),
            onPressed: () {
              if (method == null) {
                context.read<AdminCubit>().addPaymentMethod(PaymentMethodModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: titleController.text,
                  accountNumber: numberController.text,
                ));
              } else {
                context.read<AdminCubit>().updatePaymentMethod(method.copyWith(
                  name: titleController.text,
                  accountNumber: numberController.text,
                ));
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('Save', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
