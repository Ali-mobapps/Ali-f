import 'package:dynetix_app/features/dashboard/domain/entities/user_dashboard_entity.dart';

class UserDashboardModel extends UserDashboardEntity {
  const UserDashboardModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.balance,
    required super.activeTasks,
    required super.projectsCount,
  });

  factory UserDashboardModel.fromJson(Map<String, dynamic> json) {
    return UserDashboardModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'Client',
      balance: (json['balance'] ?? 0.0).toDouble(),
      activeTasks: json['activeTasks'] ?? 0,
      projectsCount: json['projectsCount'] ?? 0,
    );
  }
}