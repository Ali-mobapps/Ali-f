import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/bloc/theme_cubit.dart';
import 'core/currency/currency_cubit.dart';
import 'core/l10n/language_cubit.dart';
import 'core/notifications/notification_service.dart';
import 'core/services/deeplink_service.dart';
import 'core/services/offline_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/auth/presentation/screens/admin_login_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/role_selection_screen.dart';
import 'features/auth/presentation/screens/signup_screen.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/customer/presentation/screens/customer_dashboard_screen.dart';
import 'features/inquiries/data/repositories/inquiries_repository_impl.dart';
import 'features/inquiries/presentation/bloc/inquiries_cubit.dart';
import 'features/orders/data/repositories/orders_repository_impl.dart';
import 'features/orders/presentation/bloc/orders_cubit.dart';
import 'features/reviews/data/repositories/reviews_repository_impl.dart';
import 'features/reviews/presentation/bloc/reviews_cubit.dart';
import 'features/payments/data/repositories/payment_methods_repository_impl.dart';
import 'features/payments/presentation/bloc/payment_cubit.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/presentation/bloc/profile_cubit.dart';
import 'features/services/data/repositories/services_repository_impl.dart';
import 'features/services/presentation/bloc/services_cubit.dart';
import 'features/notifications/data/announcement_repository.dart';
import 'features/notifications/presentation/bloc/announcement_cubit.dart';
import 'features/notifications/presentation/screens/announcements_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await OfflineService.initialize();

  // 1. Initialize Supabase first (NotificationService depends on it)
  await Supabase.initialize(
    url: 'https://sqoaobghpkfjcgghalgs.supabase.co',
    publishableKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNxb2FvYmdocGtmamNnZ2hhbGdzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODYwODkxNDgsImV4cCI6MjEwMTY2NTE0OH0.qJ1cvkhSRm9-64CYG8cGyylEL6npYRGuGS0ST2SDeKk',
  );

  // 2. Initialize Firebase and Notifications
  try {
    await Firebase.initializeApp();
    await NotificationService.initialize();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  // 3. Initialize Deep Linking
  DeepLinkService.initialize();

  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
        BlocProvider<OrdersCubit>(
          create: (context) => OrdersCubit(OrdersRepositoryImpl()),
        ),
        BlocProvider<ReviewsCubit>(
          create: (context) => ReviewsCubit(ReviewsRepositoryImpl()),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<CurrencyCubit>(
          create: (context) => CurrencyCubit(),
        ),
        BlocProvider<LanguageCubit>(
          create: (context) => LanguageCubit(),
        ),
        BlocProvider<AnnouncementCubit>(
          create: (context) => AnnouncementCubit(AnnouncementRepository()),
        ),
      ],
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              return MaterialApp(
                title: 'Dynetix App',
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                themeMode: mode,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                locale: locale,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en'),
                  Locale('ur'),
                ],
                home: const SplashScreen(),
                routes: {
                  '/role-selection': (context) => const RoleSelectionScreen(),
                  '/login': (context) => const LoginScreen(),
                  '/signup': (context) => const SignUpScreen(),
                  '/admin-login': (context) => const AdminLoginScreen(),
                  '/admin-dashboard': (context) => const AdminDashboardScreen(),
                  '/customer-dashboard': (context) =>
                      const CustomerDashboardScreen(),
                  '/announcements': (context) => const AnnouncementsScreen(),
                },
              );
            },
          );
        },
      ),
    );
  }
}
