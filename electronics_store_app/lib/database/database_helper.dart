import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('electronics_store.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Users Table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'customer',
        phone TEXT,
        address TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // 2. Categories Table
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL,
        image_url TEXT
      )
    ''');

    // 3. Products Table
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL,
        image_url TEXT NOT NULL,
        stock INTEGER NOT NULL,
        rating REAL DEFAULT 4.5,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // 4. Cart Items Table
    await db.execute('''
      CREATE TABLE cart_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
      )
    ''');

    // 5. Wishlists Table
    await db.execute('''
      CREATE TABLE wishlists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
        UNIQUE(user_id, product_id)
      )
    ''');

    // 6. Orders Table
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_number TEXT UNIQUE NOT NULL,
        user_id INTEGER NOT NULL,
        total_amount REAL NOT NULL,
        delivery_fee REAL NOT NULL,
        status TEXT NOT NULL,
        payment_method TEXT NOT NULL,
        payment_status TEXT NOT NULL,
        customer_name TEXT NOT NULL,
        customer_phone TEXT NOT NULL,
        delivery_address TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 7. Order Items Table
    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        product_name TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        image_url TEXT NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE
      )
    ''');

    // Seed Initial Data
    await _seedInitialData(db);
  }

  Future<void> _seedInitialData(Database db) async {
    final now = DateTime.now().toIso8601String();

    // Seed Admin
    await db.insert('users', {
      'name': 'Store Administrator',
      'email': 'admin@electronics.com',
      'password_hash': hashPassword('admin123'),
      'role': 'admin',
      'phone': '+923001234567',
      'address': 'Admin HQ, Tech Avenue, Lahore',
      'created_at': now,
    });

    // Seed Sample Customer
    await db.insert('users', {
      'name': 'Ali Khan',
      'email': 'ali@gmail.com',
      'password_hash': hashPassword('123456'),
      'role': 'customer',
      'phone': '+923019876543',
      'address': 'House 42, Gulberg III, Lahore',
      'created_at': now,
    });

    // Seed Categories
    final categories = [
      'Smartphones',
      'Laptops',
      'Headphones',
      'Smartwatches',
      'Tablets',
      'Gaming Accessories',
      'Computer Accessories',
    ];

    for (var cat in categories) {
      await db.insert('categories', {
        'name': cat,
        'image_url': 'https://images.unsplash.com/photo-1526738549149-8e07eca6c147?auto=format&fit=crop&w=500&q=80',
      });
    }

    // Seed Products
    final products = [
      {
        'name': 'iPhone 15 Pro Max',
        'category': 'Smartphones',
        'description': 'Latest Apple flagship smartphone with Titanium design, A17 Pro chip, and advanced 5x telephoto camera system.',
        'price': 1399.00,
        'image_url': 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=500&q=80',
        'stock': 15,
        'rating': 4.9,
      },
      {
        'name': 'Samsung Galaxy S24 Ultra',
        'category': 'Smartphones',
        'description': 'AI-powered Android smartphone with built-in S Pen, 200MP camera, and Snapdragon 8 Gen 3 processor.',
        'price': 1299.00,
        'image_url': 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?auto=format&fit=crop&w=500&q=80',
        'stock': 20,
        'rating': 4.8,
      },
      {
        'name': 'MacBook Pro 16" M3 Max',
        'category': 'Laptops',
        'description': 'Ultimate pro laptop for developers and creators with stunning Liquid Retina XDR display and extreme battery life.',
        'price': 2499.00,
        'image_url': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=500&q=80',
        'stock': 10,
        'rating': 5.0,
      },
      {
        'name': 'Dell XPS 13 Plus',
        'category': 'Laptops',
        'description': 'Sleek, powerful Windows ultrabook with Intel Core i7 processor, 16GB RAM, and vibrant OLED display.',
        'price': 1499.00,
        'image_url': 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=500&q=80',
        'stock': 12,
        'rating': 4.6,
      },
      {
        'name': 'Sony WH-1000XM5',
        'category': 'Headphones',
        'description': 'Industry-leading noise canceling wireless headphones with crystal-clear hands-free calling and 30-hour battery.',
        'price': 399.00,
        'image_url': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=500&q=80',
        'stock': 25,
        'rating': 4.8,
      },
      {
        'name': 'Apple AirPods Pro (2nd Gen)',
        'category': 'Headphones',
        'description': 'Active Noise Cancellation, Adaptive Audio, Transparency mode, and Personalized Spatial Audio.',
        'price': 249.00,
        'image_url': 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?auto=format&fit=crop&w=500&q=80',
        'stock': 30,
        'rating': 4.9,
      },
      {
        'name': 'Apple Watch Ultra 2',
        'category': 'Smartwatches',
        'description': 'Rugged titanium case, precision dual-frequency GPS, up to 36 hours of battery life, and bright Always-On Retina display.',
        'price': 799.00,
        'image_url': 'https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?auto=format&fit=crop&w=500&q=80',
        'stock': 18,
        'rating': 4.9,
      },
      {
        'name': 'Samsung Galaxy Watch 6 Classic',
        'category': 'Smartwatches',
        'description': 'Timeless design with physical rotating bezel, advanced fitness tracking, and sleep coaching.',
        'price': 399.00,
        'image_url': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=500&q=80',
        'stock': 22,
        'rating': 4.7,
      },
      {
        'name': 'iPad Pro 12.9" M2',
        'category': 'Tablets',
        'description': 'Brilliant Liquid Retina XDR display, outrageous performance with M2 chip, and Apple Pencil hover support.',
        'price': 1099.00,
        'image_url': 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?auto=format&fit=crop&w=500&q=80',
        'stock': 14,
        'rating': 4.8,
      },
      {
        'name': 'Logitech G Pro X Superlight',
        'category': 'Gaming Accessories',
        'description': 'Ultra-lightweight wireless gaming mouse designed for professional esports champions.',
        'price': 159.00,
        'image_url': 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=500&q=80',
        'stock': 40,
        'rating': 4.9,
      },
      {
        'name': 'Razer Huntsman V3 Pro',
        'category': 'Gaming Accessories',
        'description': 'Analog optical gaming keyboard with adjustable actuation and rapid trigger mode.',
        'price': 249.00,
        'image_url': 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=500&q=80',
        'stock': 25,
        'rating': 4.7,
      },
      {
        'name': 'Anker 7-in-1 USB-C Hub',
        'category': 'Computer Accessories',
        'description': 'PowerDelivery pass-through charging, 4K HDMI port, SD card reader, and high-speed USB 3.0 ports.',
        'price': 59.99,
        'image_url': 'https://images.unsplash.com/photo-1625842268584-8f3296236761?auto=format&fit=crop&w=500&q=80',
        'stock': 50,
        'rating': 4.6,
      },
    ];

    for (var p in products) {
      await db.insert('products', {
        ...p,
        'created_at': now,
        'updated_at': now,
      });
    }
  }
}
