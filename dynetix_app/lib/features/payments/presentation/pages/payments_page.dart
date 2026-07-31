// File path: lib/features/payments/presentation/pages/payments_page.dart
import 'package:flutter/material.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  double _currentBalance = 0.0;

  // Professional payment methods list (Cleaned from dummy hardcoded numbers)
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'title': 'Visa ending in 4242',
      'subtitle': 'Expires 12/27',
      'type': 'card',
      'tag': 'Default',
      'icon': Icons.credit_card,
      'color': Colors.blue,
    },
  ];

  // Function to show dialog for adding new Payment Method (JazzCash, EasyPaisa, Card)
  void _showAddPaymentMethodDialog() {
    String selectedType = 'JazzCash';
    final TextEditingController accountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1D1E33),
          title: const Text('Add Payment Method', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Provider', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedType,
                dropdownColor: const Color(0xFF1D1E33),
                style: const TextStyle(color: Colors.white),
                items: ['JazzCash', 'EasyPaisa', 'Debit/Credit Card']
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {
                  setDialogState(() {
                    selectedType = value!;
                  });
                },
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF0052CC))),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: accountController,
                style: const TextStyle(color: Colors.white),
                keyboardType: selectedType == 'Debit/Credit Card' ? TextInputType.number : TextInputType.phone,
                decoration: InputDecoration(
                  hintText: selectedType == 'Debit/Credit Card' ? 'Enter Card Number' : 'Enter Mobile Number',
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF0052CC))),
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
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0052CC)),
              onPressed: () {
                if (accountController.text.isNotEmpty) {
                  setState(() {
                    if (selectedType == 'JazzCash') {
                      _paymentMethods.add({
                        'title': 'JazzCash',
                        'subtitle': accountController.text,
                        'type': 'mobile',
                        'tag': 'Mobile',
                        'icon': Icons.phone_android,
                        'color': Colors.orange,
                      });
                    } else if (selectedType == 'EasyPaisa') {
                      _paymentMethods.add({
                        'title': 'EasyPaisa',
                        'subtitle': accountController.text,
                        'type': 'mobile',
                        'tag': 'Mobile',
                        'icon': Icons.account_balance_wallet,
                        'color': Colors.green,
                      });
                    } else {
                      _paymentMethods.add({
                        'title': 'Card ending in ${accountController.text.substring(accountController.text.length >= 4 ? accountController.text.length - 4 : 0)}',
                        'subtitle': 'Secure Card',
                        'type': 'card',
                        'tag': 'Card',
                        'icon': Icons.credit_card,
                        'color': Colors.blue,
                      });
                    }
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment method added successfully!')),
                  );
                }
              },
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
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
        title: const Text('Payments', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: _showAddPaymentMethodDialog,
            tooltip: 'Add Payment Method',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Balance Card
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
                    'PKR ${_currentBalance.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment Methods Header with Add button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Payment Methods', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _showAddPaymentMethodDialog,
                  icon: const Icon(Icons.add, color: Color(0xFF0052CC), size: 18),
                  label: const Text('Add New', style: TextStyle(color: Color(0xFF0052CC))),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Payment Methods List
            Expanded(
              child: ListView.builder(
                itemCount: _paymentMethods.length,
                itemBuilder: (context, index) {
                  final method = _paymentMethods[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1E33),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(method['icon'], color: method['color']),
                      title: Text(
                        method['title'],
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        method['subtitle'],
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: method['color'].withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          method['tag'],
                          style: TextStyle(color: method['color'], fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}