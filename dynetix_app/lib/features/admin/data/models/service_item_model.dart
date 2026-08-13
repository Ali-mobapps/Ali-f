class ServiceItemModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String iconPath; // SVG path or network image URL
  final bool isAcademyCourse;

  ServiceItemModel({
    required this.id,
    required this.title,
    this.description = 'Professional service provided by Dynetix.',
    required this.price,
    this.iconPath = '',
    this.isAcademyCourse = false,
  });

  ServiceItemModel copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? iconPath,
    bool? isAcademyCourse,
  }) {
    return ServiceItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      iconPath: iconPath ?? this.iconPath,
      isAcademyCourse: isAcademyCourse ?? this.isAcademyCourse,
    );
  }
}
