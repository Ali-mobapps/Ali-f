class InventoryItem {
  final String id;
  final String title;
  final String author;
  final String category;
  final String location;
  final double costPrice;
  final double salePrice;
  final int stockLevel;
  final int minStockLevel;
  final String? isbn;

  InventoryItem({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.location,
    required this.costPrice,
    required this.salePrice,
    required this.stockLevel,
    required this.minStockLevel,
    this.isbn,
  });

  bool get isLowStock => stockLevel <= minStockLevel;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'category': category,
      'location': location,
      'costPrice': costPrice,
      'salePrice': salePrice,
      'stockLevel': stockLevel,
      'minStockLevel': minStockLevel,
      'isbn': isbn,
    };
  }

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      category: map['category'],
      location: map['location'],
      costPrice: map['costPrice'],
      salePrice: map['salePrice'],
      stockLevel: map['stockLevel'],
      minStockLevel: map['minStockLevel'],
      isbn: map['isbn'],
    );
  }
}
