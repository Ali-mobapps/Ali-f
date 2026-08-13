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
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json, String id) {
    return ServiceModel(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      imageUrl: json['image_url'],
      category: json['category'] ?? 'General',
      isActive: json['is_active'] ?? true,
      type: json['type'] ?? 'service',
      instructor: json['instructor'],
      duration: json['duration'],
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'discount_price': discountPrice,
      'image_url': imageUrl,
      'category': category,
      'is_active': isActive,
      'type': type,
      'instructor': instructor,
      'duration': duration,
      'level': level,
    };
  }
}
