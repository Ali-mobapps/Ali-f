import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/order_provider.dart';
import 'providers/drive_backup_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()..fetchProducts()),
        ChangeNotifierProvider(create: (_) => CartProvider()..fetchCart()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()..fetchProfile()),
        ChangeNotifierProvider(create: (_) => OrderProvider()..fetchOrders()),
        ChangeNotifierProvider(create: (_) => DriveBackupProvider()),
      ],
      child: const ZerenApp(),
    ),
  );
}
