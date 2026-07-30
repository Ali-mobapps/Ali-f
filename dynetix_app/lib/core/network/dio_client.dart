import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';
import 'api_interceptor.dart';

class DioClient {
  late final Dio dio;

  DioClient({required SecureStorageService secureStorage}) {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.dynetix.com/v1/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(ApiInterceptor(secureStorage));
  }
}