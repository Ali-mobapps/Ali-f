import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/vip_theme.dart';
import '../../../../core/widgets/dynetix_widgets.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../payments/data/repositories/payment_methods_repository_impl.dart';
import '../../../services/data/repositories/services_repository_impl.dart';
import '../../../services/presentation/bloc/services_cubit.dart';
import '../../../services/presentation/bloc/services_state.dart';
import '../../../services/domain/entities/service_entity.dart';

import '../../../payments/presentation/bloc/payment_cubit.dart';
import '../../../payments/presentation/bloc/payment_state.dart' as pay_state;
import '../../../inquiries/presentation/bloc/inquiries_cubit.dart';
import '../../../inquiries/presentation/bloc/inquiries_state.dart' as inq_state;
import '../../../inquiries/domain/entities/inquiry_entity.dart';

import '../../../../core/theme/bloc/theme_cubit.dart';
import '../../../settings/presentation/screens/about_screen.dart';
import '../../../settings/presentation/screens/update_screen.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';
import '../../../payments/domain/entities/payment_method_entity.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServicesCubit>().fetchServices();
      context.read<PaymentCubit>().fetchPaymentMethods();
      context.read<InquiriesCubit>().fetchInquiries('admin@dynetix.com', true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: VIPTheme.darkBackground,
      body: Row(
        children: [
          if (isDesktop) _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: _selectedIndex == 6
                      ? _buildSettingsPage()
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: _buildDashboardContent(context),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: isDesktop ? null : Drawer(child: _buildSidebarContents()),
      bottomNavigationBar: isDesktop
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedIndex >= 4 ? 3 : _selectedIndex,
              onTap: (i) => setState(() => _selectedIndex = i),
              backgroundColor: VIPTheme.cardBackground,
              selectedItemColor: VIPTheme.primaryGold,
              unselectedItemColor: Colors.white54,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.miscellaneous_services_rounded),
                    label: 'Services'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.school_rounded), label: 'Academy'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_rounded), label: 'Profile'),
              ],
            ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 260,
      color: VIPTheme.cardBackground,
      child: _buildSidebarContents(),
    );
  }

  Widget _buildSidebarContents() {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              DynetixLogo(size: 32),
              SizedBox(width: 12),
              Text(
                'DYNETIX',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: VIPTheme.primaryGold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        _buildSidebarItem(0, Icons.dashboard_outlined, 'Dashboard'),
        _buildSidebarItem(1, Icons.miscellaneous_services_outlined, 'Services'),
        _buildSidebarItem(2, Icons.school_outlined, 'Academy'),
        _buildSidebarItem(3, Icons.account_balance_wallet_outlined, 'Payment Methods'),
        _buildSidebarItem(4, Icons.chat_bubble_outline_rounded, 'Customer Messages'),
        _buildSidebarItem(5, Icons.person_outline_rounded, 'Admin Profile'),
        _buildSidebarItem(6, Icons.settings_outlined, 'Settings'),
        const Spacer(),
        _buildSidebarItem(7, Icons.logout_rounded, 'Logout', isLogout: true),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSidebarItem(int index, IconData icon, String title, {bool isLogout = false}) {
    final isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () {
          if (isLogout) {
            _showLogoutConfirmation();
          } else {
            setState(() => _selectedIndex = index);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? VIPTheme.primaryGold.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? VIPTheme.primaryGold : Colors.white70, size: 22),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? VIPTheme.primaryGold : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: VIPTheme.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to logout from the Admin Panel?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            onPressed: () {
              context.read<AuthCubit>().logout();
              Navigator.pushNamedAndRemoveUntil(context, '/role-selection', (route) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
      child: Row(
        children: [
          if (MediaQuery.of(context).size.width <= 900)
            IconButton(
              icon: const Icon(Icons.menu, color: VIPTheme.primaryGold),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          const Text(
            'Dynetix Admin',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Spacer(),
          const Icon(Icons.notifications_none_rounded, color: Colors.white70),
          const SizedBox(width: 20),
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=admin'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    if (_selectedIndex == 1) return _buildServicesManagement();
    if (_selectedIndex == 2) return _buildAcademyManagement();
    if (_selectedIndex == 3) return _buildPaymentMethodsManagement();
    if (_selectedIndex == 4) return _buildCustomerMessagesManagement();
    if (_selectedIndex == 5) return _buildAdminProfile();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome to Dynetix',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: VIPTheme.primaryGold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Manage your digital services and academy from here.',
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
        const SizedBox(height: 32),
        _buildRecentServicesTable(),
      ],
    );
  }

  Widget _buildServicesManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Services Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 24),
        _buildRecentServicesTable(),
      ],
    );
  }

  Widget _buildAcademyManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Academy Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 24),
        _buildCoursesTable(),
      ],
    );
  }

  Widget _buildCoursesTable() {
    return Card(
      color: VIPTheme.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Manage Courses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                TextButton(
                  onPressed: () => _showServiceDialog(isCourse: true),
                  child: const Text('+ Add New Course', style: TextStyle(color: VIPTheme.primaryGold)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BlocBuilder<ServicesCubit, ServicesState>(
              builder: (context, state) {
                if (state is ServicesLoading) {
                  return const Center(child: CircularProgressIndicator(color: VIPTheme.primaryGold));
                } else if (state is ServicesLoaded) {
                  final courses = state.services.where((s) => s.type == 'course').toList();
                  return Column(
                    children: [
                      const Divider(color: Colors.white10),
                      _buildTableHeader(),
                      const Divider(color: Colors.white10),
                      ...courses.map((course) => _buildTableRow(
                            course.title,
                            '\$${course.price}',
                            course.isActive ? 'Active' : 'Inactive',
                            course.isActive ? Colors.green : Colors.redAccent,
                            onEdit: () => _showServiceDialog(service: course),
                            onDelete: () => _confirmDelete(course.id),
                          )),
                    ],
                  );
                } else {
                  return const Text('No courses found.', style: TextStyle(color: Colors.white54));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Payment Methods', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            ElevatedButton.icon(
              onPressed: () => _showPaymentMethodDialog(),
              icon: const Icon(Icons.add, color: Colors.black),
              label: const Text('Add Method', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(backgroundColor: VIPTheme.primaryGold),
            ),
          ],
        ),
        const SizedBox(height: 24),
        BlocBuilder<PaymentCubit, pay_state.PaymentState>(
          builder: (context, state) {
            if (state is pay_state.PaymentLoading) {
              return const Center(child: CircularProgressIndicator(color: VIPTheme.primaryGold));
            } else if (state is pay_state.PaymentLoaded) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400,
                  mainAxisExtent: 180,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: state.payments.length,
                itemBuilder: (context, index) {
                  final method = state.payments[index];
                  return _buildPaymentMethodCard(method);
                },
              );
            }
            return const Text('No payment methods found.', style: TextStyle(color: Colors.white54));
          },
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethodEntity method) {
    Color methodColor = VIPTheme.primaryGold;
    if (method.name.toLowerCase().contains('easypaisa')) methodColor = Colors.green;
    if (method.name.toLowerCase().contains('jazzcash')) methodColor = Colors.red;
    if (method.name.toLowerCase().contains('hbl')) methodColor = const Color(0xFF006B62);

    return Card(
      color: VIPTheme.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: methodColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(method.name[0], style: TextStyle(fontWeight: FontWeight.bold, color: methodColor, fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(method.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                      Text(method.isActive ? 'Active' : 'Inactive', 
                        style: TextStyle(color: method.isActive ? Colors.green : Colors.redAccent, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(onPressed: () => _showPaymentMethodDialog(method: method), icon: const Icon(Icons.edit_outlined, size: 20, color: Colors.white70)),
              ],
            ),
            const Spacer(),
            Text('Account Title: ${method.accountTitle ?? 'Dynetix Official'}', style: const TextStyle(fontSize: 12, color: Colors.white54)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(method.accountNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2, color: Colors.white)),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 18, color: VIPTheme.primaryGold),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: method.accountNumber));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard!')));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentMethodDialog({PaymentMethodEntity? method}) {
    final nameController = TextEditingController(text: method?.name ?? '');
    final numberController = TextEditingController(text: method?.accountNumber ?? '');
    final titleController = TextEditingController(text: method?.accountTitle ?? '');
    bool isActive = method?.isActive ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: VIPTheme.cardBackground,
          title: Text(method == null ? 'Add Payment Method' : 'Edit Payment Method', style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Method Name')),
              TextField(controller: titleController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Account Title')),
              TextField(controller: numberController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Account Number')),
              SwitchListTile(
                title: const Text('Active Status', style: TextStyle(color: Colors.white)),
                value: isActive,
                onChanged: (val) => setDialogState(() => isActive = val),
              ),
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
                  accountTitle: titleController.text,
                  isActive: isActive,
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
      ),
    );
  }

  Widget _buildCustomerMessagesManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Customer Inquiries', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 24),
        BlocBuilder<InquiriesCubit, inq_state.InquiriesState>(
          builder: (context, state) {
            if (state is inq_state.InquiriesLoading) {
              return const Center(child: CircularProgressIndicator(color: VIPTheme.primaryGold));
            } else if (state is inq_state.InquiriesLoaded) {
              if (state.inquiries.isEmpty) {
                return const Center(child: Text('No inquiries yet.', style: TextStyle(color: Colors.white54)));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.inquiries.length,
                itemBuilder: (context, index) {
                  final inquiry = state.inquiries[index];
                  return _buildInquiryCard(inquiry);
                },
              );
            }
            return const Text('Something went wrong.', style: TextStyle(color: Colors.redAccent));
          },
        ),
      ],
    );
  }

  Widget _buildInquiryCard(InquiryEntity inquiry) {
    return Card(
      color: VIPTheme.cardBackground,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const CircleAvatar(
          backgroundColor: Colors.white10,
          child: Icon(Icons.person, color: VIPTheme.primaryGold),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(inquiry.userId, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            Text(
              '${inquiry.createdAt.hour}:${inquiry.createdAt.minute}',
              style: const TextStyle(fontSize: 12, color: Colors.white54),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(inquiry.message, style: const TextStyle(color: Colors.white70)),
        ),
        onTap: () => _showReplyDialog(inquiry),
      ),
    );
  }

  void _showReplyDialog(InquiryEntity inquiry) {
    final replyController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: VIPTheme.cardBackground,
        title: Text('Reply to ${inquiry.userId}', style: const TextStyle(color: Colors.white)),
        content: TextField(
          controller: replyController,
          maxLines: 4,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: 'Type your reply...', hintStyle: TextStyle(color: Colors.white38)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final newInquiry = InquiryEntity(
                id: '',
                userId: inquiry.userId,
                itemId: inquiry.itemId,
                itemType: inquiry.itemType,
                senderRole: 'admin',
                message: replyController.text,
                createdAt: DateTime.now(),
              );
              context.read<InquiriesCubit>().sendInquiry(newInquiry, 'admin@dynetix.com', true);
              Navigator.pop(context);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reply sent!')));
              }
            },
            child: const Text('Send Reply'),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminProfile() {
    return Column(
      children: [
        const Center(
          child: CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=admin'),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Super Admin', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        const Text('admin@dynetix.com', style: TextStyle(color: Colors.white54)),
        const SizedBox(height: 40),
        DynetixTextField(label: 'Full Name', hint: 'Admin', controller: TextEditingController(text: 'Dynetix Admin')),
        const SizedBox(height: 20),
        DynetixTextField(label: 'Email Address', hint: 'admin@dynetix.com', controller: TextEditingController(text: 'admin@dynetix.com')),
        const SizedBox(height: 40),
        DynetixButton(text: 'Save Changes', onPressed: () {}),
      ],
    );
  }

  Widget _buildRecentServicesTable() {
    return Card(
      color: VIPTheme.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Manage Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                TextButton(
                  onPressed: () => _showServiceDialog(),
                  child: const Text('+ Add New', style: TextStyle(color: VIPTheme.primaryGold)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BlocBuilder<ServicesCubit, ServicesState>(
              builder: (context, state) {
                if (state is ServicesLoading) {
                  return const Center(child: CircularProgressIndicator(color: VIPTheme.primaryGold));
                } else if (state is ServicesLoaded) {
                  final services = state.services.where((s) => s.type == 'service').toList();
                  return Column(
                    children: [
                      const Divider(color: Colors.white10),
                      _buildTableHeader(),
                      const Divider(color: Colors.white10),
                      ...services.map((service) => _buildTableRow(
                            service.title,
                            '\$${service.price}',
                            service.isActive ? 'Active' : 'Inactive',
                            service.isActive ? Colors.green : Colors.redAccent,
                            onEdit: () => _showServiceDialog(service: service),
                            onDelete: () => _confirmDelete(service.id),
                          )),
                    ],
                  );
                } else {
                  return const Text('No services found.', style: TextStyle(color: Colors.white54));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: VIPTheme.cardBackground,
        title: const Text('Delete Service', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this service?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<ServicesCubit>().deleteService(id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _showServiceDialog({ServiceEntity? service, bool isCourse = false}) {
    final titleController = TextEditingController(text: service?.title ?? '');
    final priceController = TextEditingController(text: service?.price.toString() ?? '');
    final descController = TextEditingController(text: service?.description ?? '');
    bool isActive = service?.isActive ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: VIPTheme.cardBackground,
          title: Text(service == null ? (isCourse ? 'Add Course' : 'Add Service') : 'Edit Item', style: const TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Title')),
                TextField(controller: priceController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
                TextField(controller: descController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
                SwitchListTile(
                  title: const Text('Active Status', style: TextStyle(color: Colors.white)),
                  value: isActive,
                  onChanged: (val) => setDialogState(() => isActive = val),
                ),
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
                  isActive: isActive,
                  category: service?.category ?? (isCourse ? 'Academy' : 'General'),
                  type: isCourse ? 'course' : 'service',
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
      ),
    );
  }

  Widget _buildTableHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('Name', style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text('Price', style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text('Status', style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text('Actions', style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildTableRow(String name, String price, String status, Color statusColor, {VoidCallback? onEdit, VoidCallback? onDelete}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500))),
          Expanded(flex: 1, child: Text(price, style: const TextStyle(color: VIPTheme.primaryGold))),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.white70), onPressed: onEdit),
                IconButton(icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent), onPressed: onDelete),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('System Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 32),
          _buildSettingsTile(Icons.dark_mode_outlined, 'Theme Mode', 
            trailing: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) => Switch(
                value: mode == ThemeMode.dark,
                onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
              ),
            ),
          ),
          _buildSettingsTile(Icons.notifications_none_rounded, 'Notifications', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen(userEmail: 'admin@dynetix.com')))),
          _buildSettingsTile(Icons.info_outline_rounded, 'About Dynetix', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()))),
          _buildSettingsTile(Icons.system_update_rounded, 'App Update', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppUpdateScreen()))),
          const SizedBox(height: 32),
          const Text('Database Initialization', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: DynetixButton(text: 'Seed Services', onPressed: () async {
                await ServicesRepositoryImpl().seedInitialData();
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Services seeded!')));
              })),
              const SizedBox(width: 20),
              Expanded(child: DynetixButton(text: 'Seed Payments', color: Colors.green, onPressed: () async {
                await PaymentMethodsRepositoryImpl().seedInitialMethods();
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payments seeded!')));
              })),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, {Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white54),
      onTap: onTap,
    );
  }
}
