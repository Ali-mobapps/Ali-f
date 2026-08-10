import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentScreen extends StatefulWidget {
  final bool isAdmin;

  const PaymentScreen({super.key, required this.isAdmin});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Pre-loaded payment accounts list
  final List<Map<String, String>> _accounts = [
    {
      'bankName': 'EasyPaisa / JazzCash',
      'accountName': 'Dynetix Official',
      'accountNumber': '0300-1234567',
    },
    {
      'bankName': 'Meezan Bank',
      'accountName': 'Dynetix Technologies',
      'accountNumber': '9876-5432109876',
    },
    {
      'bankName': 'Bank Al Habib',
      'accountName': 'Dynetix Academy',
      'accountNumber': '1234-987654321-01',
    },
  ];

  // Add or Edit Account Dialog (Only for Admin)
  void _showAddEditAccountDialog({Map<String, String>? account, int? index}) {
    final bankController =
        TextEditingController(text: account?['bankName'] ?? '');
    final nameController =
        TextEditingController(text: account?['accountName'] ?? '');
    final numberController =
        TextEditingController(text: account?['accountNumber'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(account == null ? 'Add Payment Account' : 'Edit Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: bankController,
              decoration: const InputDecoration(
                  labelText: 'Bank / Wallet Name (e.g., JazzCash)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(labelText: 'Account Title / Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: numberController,
              decoration:
                  const InputDecoration(labelText: 'Account Number / IBAN'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (bankController.text.isNotEmpty &&
                  nameController.text.isNotEmpty &&
                  numberController.text.isNotEmpty) {
                setState(() {
                  if (account == null) {
                    _accounts.add({
                      'bankName': bankController.text,
                      'accountName': nameController.text,
                      'accountNumber': numberController.text,
                    });
                  } else {
                    _accounts[index!] = {
                      'bankName': bankController.text,
                      'accountName': nameController.text,
                      'accountNumber': numberController.text,
                    };
                  }
                });
                Navigator.pop(context);
              }
            },
            child: Text(account == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  // Delete Account
  void _deleteAccount(int index) {
    setState(() {
      _accounts.removeAt(index);
    });
  }

  // Copy Account Number function for customers
  void _copyToClipboard(BuildContext context, String accountNumber) {
    Clipboard.setData(ClipboardData(text: accountNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Account number copied: $accountNumber'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.isAdmin ? 'Manage Payment Accounts' : 'Payment Accounts'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.isAdmin)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Copy the account number below, send your payment through your banking app, and share the receipt with admin.',
                  style: TextStyle(
                      color: Colors.blueAccent, fontWeight: FontWeight.w500),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _accounts.length,
                itemBuilder: (context, index) {
                  final acc = _accounts[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                acc['bankName']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                              if (widget.isAdmin)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue, size: 20),
                                      onPressed: () =>
                                          _showAddEditAccountDialog(
                                              account: acc, index: index),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red, size: 20),
                                      onPressed: () => _deleteAccount(index),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          const Divider(),
                          Text('Title: ${acc['accountName']}'),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'A/C: ${acc['accountNumber']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              if (!widget.isAdmin)
                                ElevatedButton.icon(
                                  onPressed: () => _copyToClipboard(
                                      context, acc['accountNumber']!),
                                  icon: const Icon(Icons.copy, size: 16),
                                  label: const Text('Copy'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _showAddEditAccountDialog(),
              label: const Text('Add Account'),
              icon: const Icon(Icons.add),
              backgroundColor: Colors.indigo,
            )
          : null,
    );
  }
}
