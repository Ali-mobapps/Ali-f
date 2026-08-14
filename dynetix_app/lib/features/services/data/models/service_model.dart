import '../../domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.category,
    required super.type,
    super.isActive = true,
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
      category: json['category'] ?? 'General',
      type: json['type'] ?? 'service',
      isActive: json['is_active'] ?? true,
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
      'category': category,
      'type': type,
      'is_active': isActive,
      'instructor': instructor,
      'duration': duration,
      'level': level,
    };
  }
}
