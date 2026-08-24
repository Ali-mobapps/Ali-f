class Customer {
  final String id;
  final String name;
  final String phone;
  final String address;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      address: map['address'],
    );
  }
}

class LedgerEntry {
  final String id;
  final String customerId;
  final double amount;
  final String type; // 'credit' or 'payment'
  final String timestamp;

  LedgerEntry({
    required this.id,
    required this.customerId,
    required this.amount,
    required this.type,
    required this.timestamp,
  });
}
