import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/vip_theme.dart';

class PaymentDashboard extends StatelessWidget {
  final List<Map<String, String>> payments = const [
    {"name": "Easypaisa", "number": "03451495330", "icon": "assets/images/easypaisa.png"},
    {"name": "JazzCash", "number": "03087249533", "icon": "assets/images/jazzcash.png"},
    {"name": "HBL Bank", "number": "16277900607203", "icon": "assets/images/hbl.png"},
    {"name": "NAYAPAY", "number": "03156717093", "icon": "assets/images/nayapay.png"},
    {"name": "SADAPAY", "number": "03156717093", "icon": "assets/images/sadapay.png"},
  ];

  const PaymentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VIPTheme.darkBackground,
      appBar: AppBar(
        title: const Text("Payment Methods"),
        backgroundColor: VIPTheme.darkBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: VIPTheme.primaryGold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final item = payments[index];
          return Card(
            color: VIPTheme.cardBackground,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Image.asset(item["icon"]!, errorBuilder: (_, __, ___) => const Icon(Icons.account_balance, color: VIPTheme.primaryGold)),
              ),
              title: Text(item["name"]!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: Text(item["number"]!, style: const TextStyle(fontSize: 16, color: Colors.white70)),
              trailing: IconButton(
                icon: const Icon(Icons.copy, color: VIPTheme.primaryGold),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: item["number"]!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item["name"]} number copied to clipboard!')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
