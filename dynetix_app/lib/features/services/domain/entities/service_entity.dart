class ServiceEntity {
  final String id;
  final String title;
  final String description;
  final double price;
  final double? discountPrice;
  final String? imageUrl;
  final String category;
  final bool isActive;
  final String type; // 'service' or 'course'
  final String? instructor; // For courses
  final String? duration; // For courses
  final String? level; // For courses

  const ServiceEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.discountPrice,
    this.imageUrl,
    required this.category,
    this.isActive = true,
    required this.type,
    this.instructor,
    this.duration,
    this.level,
  });
}
