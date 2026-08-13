import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';

import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/auth/presentation/screens/admin_login_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/signup_screen.dart';
import 'features/auth/presentation/screens/role_selection_screen.dart';
import 'features/inquiries/data/repositories/inquiries_repository_impl.dart';
import 'features/inquiries/presentation/bloc/inquiries_cubit.dart';
import 'features/payments/data/repositories/payment_repository_impl.dart';
import 'features/payments/data/repositories/payment_methods_repository_impl.dart';
import 'features/payments/presentation/bloc/payment_cubit.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/presentation/bloc/profile_cubit.dart';
import 'features/services/data/repositories/services_repository_impl.dart';
import 'features/services/presentation/bloc/services_cubit.dart';

import 'core/theme/bloc/theme_cubit.dart';

import 'features/notifications/data/repositories/notification_repository_impl.dart';
import 'features/notifications/presentation/bloc/notification_cubit.dart';
import 'core/theme/vip_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://sqoaobghpkfjcgghalgs.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNxb2FvYmdocGtmamNnZ2hhbGdzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODYwODkxNDgsImV4cCI6MjEwMTY2NTE0OH0.qJ1cvkhSRm9-64CYG8cGyylEL6npYRGuGS0ST2SDeKk',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) {
            final authRepo = AuthRepositoryImpl();
            return AuthCubit(
              LoginUseCase(authRepo),
              SignUpUseCase(authRepo),
              authRepo,
            )..checkAuth();
          },
        ),
        BlocProvider<ServicesCubit>(
          create: (context) => ServicesCubit(
            ServicesRepositoryImpl(),
          ),
        ),
        BlocProvider<InquiriesCubit>(
          create: (context) => InquiriesCubit(
            InquiriesRepositoryImpl(),
          ),
        ),
        BlocProvider<PaymentCubit>(
          create: (context) => PaymentCubit(
            PaymentRepositoryImpl(),
            PaymentMethodsRepositoryImpl(),
          ),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            ProfileRepositoryImpl(),
          ),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<NotificationCubit>(
          create: (context) => NotificationCubit(
            NotificationRepositoryImpl(),
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Dynetix App',
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: VIPTheme.darkVIPTheme,
            home: const RoleSelectionScreen(),
            routes: {
              '/role-selection': (context) => const RoleSelectionScreen(),
              '/login': (context) => const LoginScreen(),
              '/admin-login': (context) => const AdminLoginScreen(),
              '/customer-register': (context) => const SignUpScreen(),
            },
          );
        },
      ),
    );
  }
}
