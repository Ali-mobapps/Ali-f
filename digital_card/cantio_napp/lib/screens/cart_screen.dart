import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/canteen_logic.dart';
import 'receipt_screen.dart';

class CartScreen extends StatefulWidget {
  final Student student;
  final List<String> cartItems;
  final Map<String, double> menuCatalog;

  const CartScreen({
    super.key,
    required this.student,
    required this.cartItems,
    required this.menuCatalog,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // LLO-3: Collections (Set for Voucher System)
  final Set<String> validVouchers = {'WELCOME10', 'CAMPUS50', 'EXAMBOOST'};
  final TextEditingController _voucherController = TextEditingController();
  
  String? _appliedVoucher;
  double _voucherDiscount = 0.0;

  void _applyVoucher() {
    String input = _voucherController.text.toUpperCase().trim();
    
    // Requirement 6: Check if voucher exists in the Set
    if (validVouchers.contains(input)) {
      setState(() {
        _appliedVoucher = input;
        _voucherDiscount = 50.0; // Benefit: Rs. 50 off
        // Requirement 6: Remove from Set after successful use
        validVouchers.remove(input); 
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Voucher CAMPUS50 applied! Rs. 50 reduction.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid or already used voucher code.")),
      );
    }
  }

  void _onPayNow() {
    // Requirement 2 & 9: Authorization & Access Checks
    if (!widget.student.isActive) {
      _showAlert("Account Inactive", "Your account is not active. Order cannot be placed.");
      return;
    }

    if (widget.student.walletBalance <= 0) {
      _showAlert("Zero Balance", "Your wallet balance is zero. Please recharge.");
      return;
    }

    double subtotal = calculateTotal(widget.cartItems, widget.menuCatalog);
    double discount = applyDiscount(subtotal, widget.student.isHostelite, widget.student.loyaltyPoints);
    double total = subtotal - discount - _voucherDiscount;
    if (total < 0) total = 0;

    // Requirement 9: Compare final amount with walletBalance
    if (total > widget.student.walletBalance) {
      _showAlert("Insufficient Balance", 
        "Total bill is Rs. ${total.toStringAsFixed(2)}, but you only have Rs. ${widget.student.walletBalance.toStringAsFixed(2)}.");
      return;
    }

    // Process Payment
    double balanceBefore = widget.student.walletBalance;
    widget.student.walletBalance -= total;
    String txnId = generateTransactionId();

    // Requirement 7: Call logTransaction arrow function
    logTransaction(txnId, total);

    // Navigate to Receipt
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptScreen(
          student: widget.student,
          orderedItems: widget.cartItems,
          menuCatalog: widget.menuCatalog,
          subtotal: subtotal,
          generalDiscount: discount,
          voucherDiscount: _voucherDiscount,
          voucherCode: _appliedVoucher,
          finalAmount: total,
          balanceBefore: balanceBefore,
          txnId: txnId,
          dateTime: DateTime.now(),
        ),
      ),
    );
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK"))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = calculateTotal(widget.cartItems, widget.menuCatalog);
    double discount = applyDiscount(subtotal, widget.student.isHostelite, widget.student.loyaltyPoints);
    double total = subtotal - discount - _voucherDiscount;
    if (total < 0) total = 0;

    // Group items for display
    Map<String, int> grouped = {};
    for (var item in widget.cartItems) {
      grouped[item] = (grouped[item] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Cart"), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty."))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: grouped.length,
                    itemBuilder: (context, index) {
                      String name = grouped.keys.elementAt(index);
                      int qty = grouped.values.elementAt(index);
                      double unitPrice = widget.menuCatalog[name]!;
                      return ListTile(
                        title: Text(name),
                        subtitle: Text("Rs. $unitPrice x $qty"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Rs. ${unitPrice * qty}", style: const TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                              onPressed: () => setState(() => widget.cartItems.remove(name)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 10)],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _voucherController,
                              decoration: const InputDecoration(hintText: "Enter Voucher (e.g. WELCOME10)", isDense: true),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(onPressed: _applyVoucher, child: const Text("Apply")),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _buildRow("Subtotal", subtotal),
                      if (discount > 0) _buildRow("Discounts (incl. Loyalty)", -discount, color: Colors.green),
                      if (_voucherDiscount > 0) _buildRow("Voucher ($_appliedVoucher)", -_voucherDiscount, color: Colors.green),
                      const Divider(thickness: 2),
                      _buildRow("Total Payable", total, isBold: true),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _onPayNow,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                          child: const Text("PAY NOW", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Widget _buildRow(String label, double amount, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: isBold ? 18 : 16)),
          Text("Rs. ${amount.toStringAsFixed(2)}", 
               style: TextStyle(color: color, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: isBold ? 18 : 16)),
        ],
      ),
    );
  }
}
