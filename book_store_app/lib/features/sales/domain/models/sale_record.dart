import '../../pos/domain/models/cart_item.dart';

class SaleRecord {
  final String id;
  final DateTime dateTime;
  final List<CartItem> items;
  final double totalAmount;
  final String? customerName;
  final String status;

  SaleRecord({
    required this.id,
    required this.dateTime,
    required this.items,
    required this.totalAmount,
    this.customerName,
    this.status = 'Paid',
  });
}
