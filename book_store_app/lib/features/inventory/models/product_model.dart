class Product {
  final String id;
  final String name;
  final String type; // 'book' or 'stationery'
  final String? courseOrCategory;
  final String? rackLocation;
  final double costPrice;
  final double salePrice;
  final int stockQuantity;
  final int minStockThreshold;

  Product({
    required this.id,
    required this.name,
    required this.type,
    this.courseOrCategory,
    this.rackLocation,
    required this.costPrice,
    required this.salePrice,
    required this.stockQuantity,
    this.minStockThreshold = 3,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'course_or_category': courseOrCategory,
      'rack_location': rackLocation,
      'cost_price': costPrice,
      'sale_price': salePrice,
      'stock_quantity': stockQuantity,
      'min_stock_threshold': minStockThreshold,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      courseOrCategory: map['course_or_category'],
      rackLocation: map['rack_location'],
      costPrice: map['cost_price'],
      salePrice: map['sale_price'],
      stockQuantity: map['stock_quantity'],
      minStockThreshold: map['min_stock_threshold'],
    );
  }
}
