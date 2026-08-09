import 'package:flutter/material.dart';
import 'package:dynetix_app/core/services/supabase_service.dart';
import 'package:dynetix_app/core/services/database_service.dart';

class ServicePage extends StatefulWidget {
  final bool isAdmin;
  const ServicePage({super.key, required this.isAdmin});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  List<Map<String, dynamic>> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    try {
      setState(() => _isLoading = true);
      final data = await SupabaseService.getItems('services');
      setState(() {
        _services = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Professional Services', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _services.length,
        itemBuilder: (context, i) {
          final s = _services[i];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.design_services, color: Color(0xFF0052CC)),
              title: Text(s['title'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text(s['price'] ?? '', style: const TextStyle(color: Colors.greenAccent)),
              trailing: widget.isAdmin ? IconButton(icon: const Icon(Icons.edit), onPressed: () {}) : ElevatedButton(onPressed: () {}, child: const Text('Inquire')),
            ),
          );
        },
      ),
    );
  }
}
