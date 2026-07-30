import 'package:get_it/get_it.dart';
import 'core/storage/secure_storage_service.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core Storage
  sl.registerLazySingleton(() => SecureStorageService());

  // Auth Remote Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(),
  );

  // Auth BLoC
  sl.registerFactory<AuthBloc>(
        () => AuthBloc(remoteDataSource: sl()),
  );
}