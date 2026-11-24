class Product {
  final int? productId;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imagePath;
  final int stockQuantity;

  Product({
    this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imagePath,
    required this.stockQuantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'image_path': imagePath,
      'stock_quantity': stockQuantity,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productId: map['product_id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      price: (map['price'] as num).toDouble(),
      category: map['category'] as String? ?? 'General',
      imagePath: map['image_path'] as String? ?? '',
      stockQuantity: map['stock_quantity'] as int? ?? 10,
    );
  }
}
