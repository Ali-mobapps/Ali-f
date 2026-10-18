class ProductModel {
  final int? id;
  final String name;
  final String category;
  final String description;
  final double price;
  final String imageUrl;
  final int stock;
  final double rating;
  final String createdAt;
  final String updatedAt;

  ProductModel({
    this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.stock,
    this.rating = 4.5,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'stock': stock,
      'rating': rating,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      description: map['description'],
      price: (map['price'] as num).toDouble(),
      imageUrl: map['image_url'],
      stock: map['stock'],
      rating: (map['rating'] as num?)?.toDouble() ?? 4.5,
      createdAt: map['created_at'] ?? DateTime.now().toIso8601String(),
      updatedAt: map['updated_at'] ?? DateTime.now().toIso8601String(),
    );
  }

  ProductModel copyWith({
    int? id,
    String? name,
    String? category,
    String? description,
    double? price,
    String? imageUrl,
    int? stock,
    double? rating,
    String? createdAt,
    String? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
