import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/role_selection_screen.dart';
import 'features/inquiries/data/repositories/inquiries_repository_impl.dart';
import 'features/inquiries/presentation/bloc/inquiries_cubit.dart';
import 'features/payments/data/repositories/payment_repository_impl.dart';
import 'features/payments/presentation/bloc/payment_cubit.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/presentation/bloc/profile_cubit.dart';
import 'features/services/data/repositories/services_repository_impl.dart';
import 'features/services/presentation/bloc/services_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Bina firebase_options.dart ke default initialization
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(
            LoginUseCase(AuthRepositoryImpl()),
          ),
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
          ),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            ProfileRepositoryImpl(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Dynetix Mobile',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const RoleSelectionScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/admin-login': (context) => LoginScreen(),
          '/customer-register': (context) => LoginScreen(),
        },
      ),
    );
  }
}
