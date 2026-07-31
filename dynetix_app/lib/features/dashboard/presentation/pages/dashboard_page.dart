// File path: lib/features/dashboard/presentation/pages/dashboard_page.dart
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  final String userName;
  const DashboardPage({super.key, required this.userName});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double _totalBalance = 0.0;
  int _activeTasksCount = 0;
  int _projectsCount = 0;
  int _completedTasksCount = 0;
  int _pendingTasksCount = 0;

  final List<String> _taskList = [];
  final List<String> _paymentList = [];
  final List<String> _invoiceList = [];

  // Aapki di gayi tamam services ki list
  final List<Map<String, dynamic>> _servicesList = [
    {'title': '3D Modeling', 'icon': Icons.view_in_ar},
    {'title': 'Legal Drafting and Global Compliance', 'icon': Icons.gavel},
    {'title': 'Full Stack Development with MERN', 'icon': Icons.code},
    {'title': 'Cloud Computing', 'icon': Icons.cloud},
    {'title': 'Shopify Development and Dropshipping', 'icon': Icons.shopping_bag},
    {'title': 'Mobile Game and App Development', 'icon': Icons.phone_android},
    {'title': 'UI/UX & Webflow', 'icon': Icons.design_services},
    {'title': 'Artificial Intelligence using Python', 'icon': Icons.psychology},
    {'title': 'Startup Strategies and Entrepreneurship', 'icon': Icons.trending_up},
    {'title': 'Virtual Assistant', 'icon': Icons.support_agent},
    {'title': 'Data Analytics and Business Intelligence', 'icon': Icons.bar_chart},
    {'title': 'QuickBooks', 'icon': Icons.account_balance_wallet},
    {'title': 'SEO (Search Engine Optimization)', 'icon': Icons.search},
    {'title': 'Graphic Design', 'icon': Icons.brush},
    {'title': 'Creative Writing', 'icon': Icons.edit_note},
    {'title': 'AutoCAD', 'icon': Icons.architecture},
    {'title': 'Digital Literacy', 'icon': Icons.laptop},
    {'title': 'Digital Marketing', 'icon': Icons.campaign},
    {'title': 'E-Commerce Management', 'icon': Icons.storefront},
    {'title': 'Freelancing', 'icon': Icons.laptop_chromebook},
    {'title': 'Communication and Soft Skills', 'icon': Icons.record_voice_over},
    {'title': 'Video Editing, Animation and Vlogging', 'icon': Icons.video_collection},
    {'title': 'Affiliate Marketing', 'icon': Icons.handshake},
    {'title': 'WordPress', 'icon': Icons.web},
  ];

  void _showAddTaskDialog() {
    final TextEditingController taskController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        title: const Text('Add New Task', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: taskController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter task name...',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF0052CC))),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0052CC)),
            onPressed: () {
              if (taskController.text.isNotEmpty) {
                setState(() {
                  _taskList.add(taskController.text);
                  _activeTasksCount++;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task added successfully!')),
                );
              }
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showMakePaymentDialog() {
    final TextEditingController amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        title: const Text('Make Payment', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter amount (PKR)...',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF0052CC))),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0052CC)),
            onPressed: () {
              final val = double.tryParse(amountController.text);
              if (val != null && val > 0) {
                setState(() {
                  _totalBalance += val;
                  _paymentList.add('Paid: PKR $val');
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Payment of PKR $val processed successfully!')),
                );
              }
            },
            child: const Text('Pay', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showInvoicesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        title: const Text('Invoices', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No pending invoices available right now.', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0052CC)),
                onPressed: () {
                  setState(() {
                    _invoiceList.add('Invoice #${_invoiceList.length + 1}');
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('New invoice generated!')),
                  );
                },
                child: const Text('Generate New Invoice', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  void _showSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        title: const Text('Customer Support', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Need help? Contact our support team at support@dynetix.com or call us directly through the app.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0052CC)),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Support ticket submitted successfully!')),
              );
            },
            child: const Text('Contact Support', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E21),
        elevation: 0,
        title: const Text(
          'Welcome to Dynetix',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF1D1E33),
              child: Text(
                widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : 'U',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0052CC), Color(0xFF00C6FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Balance', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    'PKR ${_totalBalance.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Icon(Icons.account_balance_wallet, color: Colors.white70, size: 16),
                      SizedBox(width: 4),
                      Text('Real account balance', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Quick Actions', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _showAddTaskDialog,
                  child: _buildQuickActionItem(Icons.add_task, 'Add Task'),
                ),
                GestureDetector(
                  onTap: _showMakePaymentDialog,
                  child: _buildQuickActionItem(Icons.payment, 'Make Payment'),
                ),
                GestureDetector(
                  onTap: _showInvoicesDialog,
                  child: _buildQuickActionItem(Icons.description_outlined, 'Invoices'),
                ),
                GestureDetector(
                  onTap: _showSupportDialog,
                  child: _buildQuickActionItem(Icons.support_agent, 'Support'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Overview', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildOverviewCard('Active Tasks', '$_activeTasksCount', 'Updated live', Colors.blue),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildOverviewCard('Projects', '$_projectsCount', 'Updated live', Colors.purple),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildOverviewCard('Completed', '$_completedTasksCount', 'Finished items', Colors.green),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildOverviewCard('Pending', '$_pendingTasksCount', 'In progress', Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Dynetix Services & Programs', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _servicesList.length,
              itemBuilder: (context, index) {
                final service = _servicesList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D1E33),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(service['icon'], color: const Color(0xFF00C6FF), size: 24),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          service['title'],
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1D1E33),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF0052CC), size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildOverviewCard(String title, String value, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}