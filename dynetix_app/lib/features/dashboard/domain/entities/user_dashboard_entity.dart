class UserDashboardEntity {
  final String id;
  final String name;
  final String email;
  final String role;
  final double balance;
  final int activeTasks;
  final int projectsCount;

  const UserDashboardEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.balance,
    required this.activeTasks,
    required this.projectsCount,
  });
}