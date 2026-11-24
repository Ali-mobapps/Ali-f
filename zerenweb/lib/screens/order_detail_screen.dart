import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order_model.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_PK', symbol: 'Rs. ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2D52),
        title: Text('Order #ZR-${order.orderId}', style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Date Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Order Date', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(order.orderDate.substring(0, 10), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Status', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(order.orderStatus, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD4AF37))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Customer & Delivery Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Delivery Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Divider(height: 16),
                  Text('Name: ${order.customerName}'),
                  const SizedBox(height: 6),
                  Text('Phone: ${order.customerPhone}'),
                  const SizedBox(height: 6),
                  Text('Address: ${order.deliveryAddress}'),
                  const SizedBox(height: 6),
                  Text('Payment: ${order.paymentMethod}'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Ordered Items
            const Text('Ordered Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items?.length ?? 0,
              itemBuilder: (context, index) {
                final item = order.items![index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Qty: ${item.quantity} x ${currencyFormat.format(item.unitPrice)}', style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      Text(
                        currencyFormat.format(item.totalPrice),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F2D52)),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Total Amount Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F2D52),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Amount Paid', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text(
                    currencyFormat.format(order.totalAmount),
                    style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
