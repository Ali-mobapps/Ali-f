import 'package:equatable/equatable.dart';

class AnnouncementEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final String type; // 'global', 'enrolled', 'system'

  const AnnouncementEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.type,
  });

  @override
  List<Object?> get props => [id, title, content, createdAt, type];
}
