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

  // Lists for tasks, projects, payments and saved methods
  final List<String> _taskList = [];
  final List<String> _projectList = [];
  final List<String> _paymentList = [];
  final List<String> _invoiceList = [];
  final List<Map<String, String>> _savedPaymentMethods = [
    {'title': 'Visa ending in 4242', 'subtitle': 'Expires 12/27', 'type': 'Card'}
  ];
  final List<String> _notifications = [
    'Welcome to Dynetix! Explore our services.',
    'Your payment gateway is successfully configured.',
  ];

  // Services list
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

  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        title: const Text('Notifications', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.notifications, color: Color(0xFF00C6FF)),
                title: Text(_notifications[index], style: const TextStyle(color: Colors.white, fontSize: 13)),
              );
            },
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

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        title: const Text('User Profile', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFF0052CC),
              child: Text(
                widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : 'U',
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Text(widget.userName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Active Member', style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

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
            hintText: 'Enter task title...',
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

  void _showAddProjectDialog() {
    final TextEditingController projectController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        title: const Text('Add New Project', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: projectController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter project title...',
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
              if (projectController.text.isNotEmpty) {
                setState(() {
                  _projectList.add(projectController.text);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Project added successfully!')),
                );
              }
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddPaymentMethodDialog() {
    final TextEditingController detailController = TextEditingController();
    String selectedMethod = 'EasyPaisa';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1D1E33),
          title: const Text('Add Payment Method', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select Type', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedMethod,
                  dropdownColor: const Color(0xFF1D1E33),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF0052CC))),
                  ),
                  items: ['EasyPaisa', 'JazzCash', 'Bank Transfer', 'Visa / Master Card']
                      .map((method) => DropdownMenuItem(
                    value: method,
                    child: Text(method),
                  ))
                      .toList(),
                  onChanged: (val) {
                    setDialogState(() {
                      selectedMethod = val!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: detailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: selectedMethod.contains('Card') ? 'Card Number / Details' : 'Mobile Number / Account No',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF0052CC))),
                  ),
                ),
              ],
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
                if (detailController.text.isNotEmpty) {
                  setState(() {
                    _savedPaymentMethods.add({
                      'title': '$selectedMethod (${detailController.text})',
                      'subtitle': 'Linked account',
                      'type': selectedMethod,
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$selectedMethod added successfully!')),
                  );
                }
              },
              child: const Text('Save Method', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showMakePaymentDialog() {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController refController = TextEditingController();
    String selectedMethod = 'EasyPaisa';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1D1E33),
          title: const Text('Make Real Payment', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select Payment Method', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedMethod,
                  dropdownColor: const Color(0xFF1D1E33),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF0052CC))),
                  ),
                  items: ['EasyPaisa', 'JazzCash', 'Bank Transfer', 'Stripe Card']
                      .map((method) => DropdownMenuItem(
                    value: method,
                    child: Text(method),
                  ))
                      .toList(),
                  onChanged: (val) {
                    setDialogState(() {
                      selectedMethod = val!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Enter Amount (PKR)',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF0052CC))),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: refController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Transaction ID / Reference No',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF0052CC))),
                  ),
                ),
              ],
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
                    _paymentList.add('$selectedMethod: PKR $val (Ref: ${refController.text})');
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully added PKR $val via $selectedMethod!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid amount')),
                  );
                }
              },
              child: const Text('Confirm Payment', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
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
          'Payments & Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: _showNotificationsDialog,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: _showProfileDialog,
              child: CircleAvatar(
                backgroundColor: const Color(0xFF1D1E33),
                child: Text(
                  widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : 'U',
                  style: const TextStyle(color: Colors.white),
                ),
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
            // Balance Card
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
                  const Text('Current Balance', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    'PKR ${_totalBalance.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment Methods Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Payment Methods', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _showAddPaymentMethodDialog,
                  icon: const Icon(Icons.add, color: Color(0xFF00C6FF), size: 16),
                  label: const Text('Add New', style: TextStyle(color: Color(0xFF00C6FF))),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _savedPaymentMethods.length,
              itemBuilder: (context, index) {
                final method = _savedPaymentMethods[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D1E33),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.payment, color: Color(0xFF00C6FF), size: 24),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(method['title']!, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(method['subtitle']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      if (index == 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0052CC),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Default', style: TextStyle(color: Colors.white, fontSize: 11)),
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                          onPressed: () {
                            setState(() {
                              _savedPaymentMethods.removeAt(index);
                            });
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Quick Actions Section
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
                  onTap: _showAddProjectDialog,
                  child: _buildQuickActionItem(Icons.create_new_folder, 'Add Project'),
                ),
                GestureDetector(
                  onTap: _showMakePaymentDialog,
                  child: _buildQuickActionItem(Icons.payment, 'Payment'),
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

            // Overview Section (Active Tasks & Projects)
            const Text('Overview', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildOverviewCard('Active Tasks', '${_taskList.length}', 'Updated live', Colors.blue),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildOverviewCard('Projects', '${_projectList.length}', 'Updated live', Colors.purple),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Dynetix Services & Programs Section
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1D1E33),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF0052CC), size: 22),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
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