// File path: lib/features/dashboard/presentation/pages/dashboard_page.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dynetix_app/core/services/database_service.dart';
import 'admin_panel_page.dart';

class DashboardPage extends StatefulWidget {
  final String userEmail;
  const DashboardPage({super.key, required this.userEmail});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null && AppDatabase.currentUser != null) {
      if (kIsWeb) {
        var bytes = await image.readAsBytes();
        setState(() {
          AppDatabase.currentUser!['webImageBytes'] = bytes;
        });
      } else {
        setState(() {
          AppDatabase.currentUser!['imagePath'] = image.path;
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated!')),
        );
      }
    }
  }

  void _openPaymentDialog(String title, double amount) {
    String selectedMethod = 'JazzCash';
    final accountCtrl = TextEditingController();
    final pinCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          String adminTarget = selectedMethod == 'JazzCash'
              ? AppDatabase.adminJazzCash
              : selectedMethod == 'EasyPaisa'
              ? AppDatabase.adminEasyPaisa
              : AppDatabase.adminBank;

          return AlertDialog(
            backgroundColor: const Color(0xFF1D1E33),
            title: Text('Pay for: $title', style: const TextStyle(color: Colors.white, fontSize: 14)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount: PKR ${amount.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFF00C6FF), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: selectedMethod,
                    dropdownColor: const Color(0xFF1D1E33),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    items: ['JazzCash', 'EasyPaisa', 'Bank Transfer'].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedMethod = val);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Send money to Admin Account:', style: TextStyle(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.bold)),
                        Text(adminTarget, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(controller: accountCtrl, keyboardType: TextInputType.phone, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Your Account No', labelStyle: TextStyle(color: Colors.grey, fontSize: 11))),
                  TextField(controller: pinCtrl, obscureText: true, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'PIN / Password', labelStyle: TextStyle(color: Colors.grey, fontSize: 11))),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  if (accountCtrl.text.isNotEmpty && pinCtrl.text.isNotEmpty) {
                    setState(() {
                      AppDatabase.totalRevenue += amount;
                      AppDatabase.allPaymentsLog.add({'client': AppDatabase.currentUser!['name'], 'item': title, 'amount': amount});
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment processed successfully!')));
                  }
                },
                child: const Text('Pay Now', style: TextStyle(color: Colors.white, fontSize: 11)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = AppDatabase.currentUser ?? {'name': 'User', 'email': widget.userEmail, 'isAdmin': false, 'imagePath': null};
    bool isAdmin = user['isAdmin'] ?? false;
    final String? imagePath = user['imagePath'];
    final Uint8List? webBytes = user['webImageBytes'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF0052CC), Color(0xFF00C6FF)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      backgroundImage: webBytes != null
                          ? MemoryImage(webBytes)
                          : (imagePath != null ? FileImage(File(imagePath)) as ImageProvider : null),
                      child: (webBytes == null && imagePath == null) ? const Icon(Icons.person, size: 30, color: Color(0xFF0052CC)) : null,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user['name'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(user['email'], style: const TextStyle(color: Colors.white70, fontSize: 11)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF0052CC)),
                      onPressed: _pickProfileImage,
                      child: const Text('Photo', style: TextStyle(fontSize: 10)),
                    ),
                  ],
                ),
                if (isAdmin) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0052CC),
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminPanelPage())),
                      icon: const Icon(Icons.admin_panel_settings, color: Color(0xFF0052CC), size: 16),
                      label: const Text('Open Admin Management Panel', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Available Services Catalog (Dynamic from Admin)
          const Text('🛠️ Available Services', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...AppDatabase.servicesCatalog.map((s) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF1D1E33), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.code, color: Color(0xFF00C6FF), size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s['title'], style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      Text('PKR ${s['price']}', style: const TextStyle(color: Colors.greenAccent, fontSize: 11)),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0052CC)),
                  onPressed: () => _openPaymentDialog(s['title'], s['price']),
                  child: const Text('Order & Pay', style: TextStyle(color: Colors.white, fontSize: 11)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}