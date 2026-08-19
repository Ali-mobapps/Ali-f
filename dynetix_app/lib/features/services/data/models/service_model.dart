import '../../domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    super.discountPrice,
    super.imageUrl,
    required super.category,
    super.isActive = true,
    required super.type,
    super.instructor,
    super.duration,
    super.level,
    super.portfolioUrls = const [],
    super.averageRating = 5.0,
    super.totalReviews = 0,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json, String id) {
    return ServiceModel(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      imageUrl: json['image_url'],
      category: json['category'] ?? 'Elite',
      isActive: json['is_active'] ?? true,
      type: json['type'] ?? 'service',
      instructor: json['instructor'],
      duration: json['duration'],
      level: json['level'],
      portfolioUrls: List<String>.from(json['portfolio_urls'] ?? []),
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 5.0,
      totalReviews: json['total_reviews'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    // Only include columns that we are 100% sure exist in the basic table
    return {
      'title': title,
      'description': description,
      'price': price,
      'discount_price': discountPrice,
      'category': category,
      'is_active': isActive,
      'type': type,
      'portfolio_urls': portfolioUrls,
      'average_rating': averageRating,
      'total_reviews': totalReviews,
    };
  }
}
