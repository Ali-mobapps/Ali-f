import 'dart:convert';
import 'package:crypto/crypto.dart';

class WebDatabaseMock {
  final Map<String, List<Map<String, dynamic>>> tables = {
    'users': [],
    'categories': [],
    'products': [],
    'cart_items': [],
    'wishlists': [],
    'orders': [],
    'order_items': [],
  };

  int _autoIncrementId = 1;

  WebDatabaseMock() {
    _seedData();
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _seedData() {
    final now = DateTime.now().toIso8601String();

    tables['users']!.add({
      'id': _autoIncrementId++,
      'name': 'Store Administrator',
      'email': 'admin@electronics.com',
      'password_hash': hashPassword('admin123'),
      'role': 'admin',
      'phone': '+923001234567',
      'address': 'Admin HQ, Tech Avenue, Lahore',
      'created_at': now,
    });

    tables['users']!.add({
      'id': _autoIncrementId++,
      'name': 'Ali Khan',
      'email': 'ali@gmail.com',
      'password_hash': hashPassword('123456'),
      'role': 'customer',
      'phone': '+923019876543',
      'address': 'House 42, Gulberg III, Lahore',
      'created_at': now,
    });

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
      tables['categories']!.add({
        'id': _autoIncrementId++,
        'name': cat,
        'image_url': 'https://images.unsplash.com/photo-1526738549149-8e07eca6c147?auto=format&fit=crop&w=500&q=80',
      });
    }

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
        'name': 'Google Pixel 8 Pro',
        'category': 'Smartphones',
        'description': 'Google Tensor G3 chip with pro camera features, Magic Eraser, and Best Take AI photography.',
        'price': 999.00,
        'image_url': 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=500&q=80',
        'stock': 18,
        'rating': 4.7,
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
      tables['products']!.add({
        'id': _autoIncrementId++,
        'name': p['name'],
        'category': p['category'],
        'description': p['description'],
        'price': p['price'],
        'image_url': p['image_url'],
        'stock': p['stock'],
        'rating': p['rating'],
        'created_at': now,
        'updated_at': now,
      });
    }
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    var rows = tables[table] ?? [];

    if (where != null && whereArgs != null) {
      rows = rows.where((row) {
        if (where == 'email = ? AND password_hash = ?') {
          return row['email'] == whereArgs[0] && row['password_hash'] == whereArgs[1];
        } else if (where == 'email = ?') {
          return row['email'] == whereArgs[0];
        } else if (where == 'id = ?') {
          return row['id'] == whereArgs[0];
        } else if (where == 'user_id = ?') {
          return row['user_id'] == whereArgs[0];
        } else if (where == 'order_id = ?') {
          return row['order_id'] == whereArgs[0];
        } else if (where == 'user_id = ? AND product_id = ?') {
          return row['user_id'] == whereArgs[0] && row['product_id'] == whereArgs[1];
        }
        return true;
      }).toList();
    }

    return rows.map((r) => Map<String, dynamic>.from(r)).toList();
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final newRow = Map<String, dynamic>.from(values);
    if (!newRow.containsKey('id') || newRow['id'] == null) {
      newRow['id'] = _autoIncrementId++;
    }
    tables[table]!.add(newRow);
    return newRow['id'] as int;
  }

  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
    int? conflictAlgorithm,
  }) async {
    int count = 0;
    for (var row in tables[table]!) {
      bool match = true;
      if (where != null && whereArgs != null) {
        if (where == 'id = ?') {
          match = row['id'] == whereArgs[0];
        } else if (where == 'user_id = ? AND product_id = ?') {
          match = row['user_id'] == whereArgs[0] && row['product_id'] == whereArgs[1];
        }
      }
      if (match) {
        row.addAll(values);
        count++;
      }
    }
    return count;
  }

  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    int count = 0;
    tables[table]!.removeWhere((row) {
      bool match = false;
      if (where != null && whereArgs != null) {
        if (where == 'id = ?') {
          match = row['id'] == whereArgs[0];
        } else if (where == 'user_id = ?') {
          match = row['user_id'] == whereArgs[0];
        } else if (where == 'order_id = ?') {
          match = row['order_id'] == whereArgs[0];
        } else if (where == 'user_id = ? AND product_id = ?') {
          match = row['user_id'] == whereArgs[0] && row['product_id'] == whereArgs[1];
        }
      } else {
        match = true;
      }
      if (match) count++;
      return match;
    });
    return count;
  }

  Future<void> execute(String sql, [List<Object?>? arguments]) async {}

  Future<T> transaction<T>(Future<T> Function(WebDatabaseMock txn) action) async {
    return await action(this);
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  WebDatabaseMock? _mockDb;

  DatabaseHelper._init();

  Future<dynamic> get database async {
    _mockDb ??= WebDatabaseMock();
    return _mockDb!;
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
