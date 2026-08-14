import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';

import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/auth/presentation/screens/role_selection_screen.dart';
import 'features/services/data/repositories/services_repository_impl.dart';
import 'features/services/presentation/bloc/services_cubit.dart';
import 'features/inquiries/data/repositories/inquiries_repository_impl.dart';
import 'features/inquiries/presentation/bloc/inquiries_cubit.dart';
import 'features/payments/data/repositories/payment_methods_repository_impl.dart';
import 'features/payments/presentation/bloc/payment_cubit.dart';
git add .import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/presentation/bloc/profile_cubit.dart';

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
          create: (context) => AuthCubit(AuthRepositoryImpl())..checkAuth(),
        ),
        BlocProvider<ServicesCubit>(
          create: (context) => ServicesCubit(ServicesRepositoryImpl()),
        ),
        BlocProvider<InquiriesCubit>(
          create: (context) => InquiriesCubit(InquiriesRepositoryImpl()),
        ),
        BlocProvider<PaymentCubit>(
          create: (context) => PaymentCubit(PaymentMethodsRepositoryImpl()),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(ProfileRepositoryImpl()),
        ),
      ],
      child: MaterialApp(
        title: 'Dynetix VIP',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const RoleSelectionScreen(),
      ),
    );
  }
}
