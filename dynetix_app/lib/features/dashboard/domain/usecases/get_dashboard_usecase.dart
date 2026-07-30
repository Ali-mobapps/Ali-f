import '../entities/user_dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardUseCase {
  final DashboardRepository repository;

  GetDashboardUseCase(this.repository);

  Future<UserDashboardEntity> call() async {
    return await repository.getDashboardData();
  }
}