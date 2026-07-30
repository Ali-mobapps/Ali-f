import '../../../../core/constants/app_constants.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({dynamic dio});

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    // Fake Network Delay (1.5 seconds) to simulate real API call
    await Future.delayed(const Duration(milliseconds: 1500));

    // Simulated Successful Response
    return {
      'user': {
        'id': 'usr_123456',
        'name': 'Ali Hassan',
        'email': email,
      },
      'token': 'mock_jwt_token_dynetix_987654321',
    };
  }
}