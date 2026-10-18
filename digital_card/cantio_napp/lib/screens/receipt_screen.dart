import 'package:flutter/material.dart';
import '../models/student.dart';
import 'profile_setup_screen.dart';

class ReceiptScreen extends StatelessWidget {
  final Student student;
  final List<String> orderedItems;
  final Map<String, double> menuCatalog;
  final double subtotal;
  final double generalDiscount;
  final double voucherDiscount;
  final String? voucherCode;
  final double finalAmount;
  final double balanceBefore;
  final String txnId;
  final DateTime dateTime;

  const ReceiptScreen({
    super.key,
    required this.student,
    required this.orderedItems,
    required this.menuCatalog,
    required this.subtotal,
    required this.generalDiscount,
    required this.voucherDiscount,
    this.voucherCode,
    required this.finalAmount,
    required this.balanceBefore,
    required this.txnId,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    // Group items for itemized receipt
    Map<String, int> grouped = {};
    for (var item in orderedItems) {
      grouped[item] = (grouped[item] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Digital Receipt"), automaticallyImplyLeading: false, backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 10),
            const Text("Payment Successful!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(child: Text("SMART CAMPUS CANTEEN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                    const Divider(),
                    Text("Transaction ID: $txnId"),
                    Text("Date: ${dateTime.toString().split('.')[0]}"),
                    const SizedBox(height: 10),
                    // Requirement 8: Student Details
                    Text("Student: ${student.studentName}"),
                    Text("ID: ${student.studentId}"),
                    Text("Type: ${student.isHostelite ? 'Hostelite' : 'Day Scholar'}"),
                    const Divider(),
                    const Text("ITEMIZED BILL", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    // Requirement 8: Ordered items, qty, prices
                    ...grouped.entries.map((e) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${e.key} (x${e.value})"),
                        Text("Rs. ${(menuCatalog[e.key]! * e.value).toStringAsFixed(2)}"),
                      ],
                    )),
                    const Divider(),
                    _receiptRow("Subtotal", subtotal),
                    if (generalDiscount > 0) _receiptRow("Campus Discount", -generalDiscount),
                    if (voucherDiscount > 0) _receiptRow("Voucher ($voucherCode)", -voucherDiscount),
                    _receiptRow("Tax (GST)", 0.0), // As per Requirement 8: display Rs. 0
                    const Divider(),
                    _receiptRow("Final Amount", finalAmount, isBold: true),
                    const SizedBox(height: 10),
                    _receiptRow("Wallet (Before)", balanceBefore),
                    _receiptRow("Remaining Balance", student.walletBalance, isBold: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Restart the app / go to setup
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                child: const Text("DONE / NEW ORDER", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _receiptRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text("Rs. ${amount.toStringAsFixed(2)}", style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
