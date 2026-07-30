import '../../domain/entities/user_dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserDashboardEntity> getDashboardData() async {
    final model = await remoteDataSource.getDashboardData();
    return model;
  }
}