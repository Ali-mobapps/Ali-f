// File path: lib/features/dashboard/data/datasources/dashboard_remote_data_source.dart
import '../models/user_dashboard_model.dart';

abstract class DashboardRemoteDataSource {
  Future<UserDashboardModel> getDashboardData();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  @override
  Future<UserDashboardModel> getDashboardData() async {
    // Simulated Successful Response
    return UserDashboardModel(
      id: 'usr_123456',
      name: 'Ali Hassan',
      email: 'ali@dynetix.com',
      role: 'Admin',
      balance: 0.0,
      activeTasks: 0,
      projectsCount: 0,
    );
  }
}