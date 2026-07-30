import '../entities/user_dashboard_entity.dart';

abstract class DashboardRepository {
  Future<UserDashboardEntity> getDashboardData();
}