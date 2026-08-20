class Invoice {
  final String? id;
  final String serialNo;
  final String invoiceNo;
  final String dcNo;
  final DateTime date;
  final String? orderNo;
  final String? dcNo2;
  final String clientName;
  final String invoicedTo;
  final String address;
  final List<InvoiceItem> items;
  final double discount;

  Invoice({
    this.id,
    required this.serialNo,
    required this.invoiceNo,
    required this.dcNo,
    required this.date,
    this.orderNo,
    this.dcNo2,
    required this.clientName,
    this.invoicedTo = "Same",
    required this.address,
    required this.items,
    this.discount = 0.0,
  });

  double get grossAmount => items.fold(0, (sum, item) => sum + item.amount);
  double get totalDue => grossAmount - discount;
  double get totalAmount => totalDue; // Added to fix missing getter error

  Map<String, dynamic> toMap() {
    return {
      'serial_no': serialNo,
      'invoice_no': invoiceNo,
      'dc_no': dcNo,
      'date': date.toIso8601String(),
      'order_no': orderNo,
      'dc_no2': dcNo2,
      'client_name': clientName,
      'invoiced_to': invoicedTo,
      'address': address,
      'discount': discount,
    };
  }
}

class InvoiceItem {
  final String productName;
  final String packing;
  final String qty;
  final String? bonus;
  final double unitRate;

  InvoiceItem({
    required this.productName,
    required this.packing,
    required this.qty,
    this.bonus,
    required this.unitRate,
  });

  double get amount {
    final numericQty = double.tryParse(qty.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
    return numericQty * unitRate;
  }

  Map<String, dynamic> toMap(String invoiceId) {
    return {
      'invoice_id': invoiceId,
      'product_name': productName,
      'packing': packing,
      'qty': qty,
      'bonus': bonus,
      'unit_rate': unitRate,
      'amount': amount,
    };
  }
}
