class Sale {
  final String id;
  final String? customerId;
  final String timestamp;
  final double totalAmount;
  final double discount;
  final double finalAmount;

  Sale({
    required this.id,
    this.customerId,
    required this.timestamp,
    required this.totalAmount,
    required this.discount,
    required this.finalAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'timestamp': timestamp,
      'total_amount': totalAmount,
      'discount': discount,
      'final_amount': finalAmount,
    };
  }
}

class SaleItem {
  final String id;
  final String saleId;
  final String productId;
  final int quantity;
  final double priceAtSale;

  SaleItem({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.quantity,
    required this.priceAtSale,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sale_id': saleId,
      'product_id': productId,
      'quantity': quantity,
      'price_at_sale': priceAtSale,
    };
  }
}
