// File path: lib/features/dashboard/presentation/pages/admin_panel_page.dart
import 'package:flutter/material.dart';
import 'package:dynetix_app/core/services/database_service.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  final _serviceNameController = TextEditingController();
  final _servicePriceController = TextEditingController();

  final _jazzController = TextEditingController(text: AppDatabase.adminJazzCash);
  final _easyController = TextEditingController(text: AppDatabase.adminEasyPaisa);
  final _bankController = TextEditingController(text: AppDatabase.adminBank);

  // Service Edit Dialog
  void _showEditServiceDialog(Map<String, dynamic> service, int index) {
    final nameCtrl = TextEditingController(text: service['title']);
    final priceCtrl = TextEditingController(text: service['price'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1D1E33),
        title: const Text('Edit Service', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Service Name',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Service Price (PKR)',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: () {
              final newName = nameCtrl.text.trim();
              final newPrice = double.tryParse(priceCtrl.text.trim()) ?? service['price'];
              if (newName.isNotEmpty) {
                setState(() {
                  AppDatabase.servicesCatalog[index]['title'] = newName;
                  AppDatabase.servicesCatalog[index]['price'] = newPrice;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Service updated successfully!')),
                );
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
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
        title: const Text('Admin Management Panel', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Revenue Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1D1E33),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Revenue:', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('PKR ${AppDatabase.totalRevenue.toStringAsFixed(0)}', style: const TextStyle(color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Add Service Section
            const Text('Add New Service', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _serviceNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Service Name',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1D1E33),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _servicePriceController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Price (PKR)',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1D1E33),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              onPressed: () {
                if (_serviceNameController.text.isNotEmpty && _servicePriceController.text.isNotEmpty) {
                  setState(() {
                    AppDatabase.servicesCatalog.add({
                      'title': _serviceNameController.text,
                      'price': double.tryParse(_servicePriceController.text) ?? 0.0,
                      'icon': 'devices',
                    });
                  });
                  _serviceNameController.clear();
                  _servicePriceController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Service Added!')));
                }
              },
              child: const Text('Add Service', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 25),

            // Manage Services Section with Edit & Delete
            const Text('Manage Services', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: AppDatabase.servicesCatalog.length,
              itemBuilder: (context, index) {
                final service = AppDatabase.servicesCatalog[index];
                return Card(
                  color: const Color(0xFF1D1E33),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(service['title'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text('PKR ${service['price']}', style: const TextStyle(color: Colors.greenAccent)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () => _showEditServiceDialog(service, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            setState(() {
                              AppDatabase.servicesCatalog.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}