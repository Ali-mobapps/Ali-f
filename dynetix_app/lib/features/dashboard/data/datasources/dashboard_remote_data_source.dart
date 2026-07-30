import '../models/user_dashboard_model.dart';

abstract class DashboardRemoteDataSource {
  Future<UserDashboardModel> getDashboardData();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl();

  @override
  Future<UserDashboardModel> getDashboardData() async {
    // Fake Network Delay (1 second) to simulate real API call
    await Future.delayed(const Duration(milliseconds: 1000));

    // Simulated Successful Response with balance set to 0 and initial counts
    return const UserDashboardModel(
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