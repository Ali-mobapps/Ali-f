import 'package:equatable/equatable.dart';

class ServiceEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String type; // 'service' or 'course'
  final bool isActive;
  final String? instructor;
  final String? duration;
  final String? level;
  final double? discountPrice;
  final String? imageUrl;
  final List<String> portfolioUrls;
  final double averageRating;
  final int totalReviews;

  const ServiceEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.type,
    this.isActive = true,
    this.instructor,
    this.duration,
    this.level,
    this.discountPrice,
    this.imageUrl,
    this.portfolioUrls = const [],
    this.averageRating = 5.0,
    this.totalReviews = 0,
  });

  @override
  List<Object?> get props => [id, title, price, type, isActive, averageRating];
}
