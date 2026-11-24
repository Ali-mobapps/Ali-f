import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';
import '../models/user_profile_model.dart';
import '../models/order_model.dart';
import '../models/order_item_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('zeren_watches.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Products Table
    await db.execute('''
      CREATE TABLE products (
        product_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        category TEXT NOT NULL,
        image_path TEXT,
        stock_quantity INTEGER NOT NULL
      )
    ''');

    // 2. Cart Items Table
    await db.execute('''
      CREATE TABLE cart_items (
        cart_id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE CASCADE
      )
    ''');

    // 3. User Profile Table
    await db.execute('''
      CREATE TABLE user_profile (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        phone_number TEXT,
        delivery_address TEXT
      )
    ''');

    // 4. Orders Table
    await db.execute('''
      CREATE TABLE orders (
        order_id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        order_date TEXT NOT NULL,
        total_amount REAL NOT NULL,
        delivery_address TEXT NOT NULL,
        customer_name TEXT NOT NULL,
        customer_phone TEXT NOT NULL,
        payment_method TEXT NOT NULL,
        order_status TEXT NOT NULL
      )
    ''');

    // 5. Order Items Table
    await db.execute('''
      CREATE TABLE order_items (
        order_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        product_name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders (order_id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products (product_id)
      )
    ''');

    // Insert Default User Profile
    await db.insert('user_profile', {
      'name': 'Zeren Customer',
      'email': 'customer@zerenwatches.com',
      'phone_number': '+92 300 9876543',
      'delivery_address': 'DHA Phase 5, Lahore, Pakistan'
    });

    // Insert Demo Products
    final List<Map<String, dynamic>> demoProducts = [
      {
        'name': 'ZEREN Royal Chronograph',
        'description': 'Luxurious navy dial with gold-plated stainless steel bezel and genuine leather strap. Water resistant up to 50M.',
        'price': 45000.0,
        'category': 'Formal',
        'image_path': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&auto=format&fit=crop&q=80',
        'stock_quantity': 15,
      },
      {
        'name': 'ZEREN Executive Gold',
        'description': 'Pure 18K gold-tone finish with minimalist Roman numerals. Designed for formal galas and corporate leaders.',
        'price': 62000.0,
        'category': 'Formal',
        'image_path': 'https://images.unsplash.com/photo-1542496658-e33a6d0d50f6?w=600&auto=format&fit=crop&q=80',
        'stock_quantity': 8,
      },
      {
        'name': 'ZEREN Sport Diver Pro',
        'description': 'Rugged titanium case with rotating bezel and luminescent hands. Built for deep sea diving and extreme adventures.',
        'price': 38000.0,
        'category': 'Sport',
        'image_path': 'https://images.unsplash.com/photo-1533139502658-0198f920d8e8?w=600&auto=format&fit=crop&q=80',
        'stock_quantity': 20,
      },
      {
        'name': 'ZEREN Classic Heritage',
        'description': 'Vintage round face with sapphire crystal glass and dark brown leather strap. Timeless elegance for everyday wear.',
        'price': 29500.0,
        'category': 'Casual',
        'image_path': 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=600&auto=format&fit=crop&q=80',
        'stock_quantity': 25,
      },
      {
        'name': 'ZEREN Carbon Elite',
        'description': 'Matte black carbon fiber body with modern chronograph sub-dials. Ultra-lightweight and striking design.',
        'price': 55000.0,
        'category': 'Premium',
        'image_path': 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&auto=format&fit=crop&q=80',
        'stock_quantity': 10,
      },
      {
        'name': 'ZEREN Urban Steel',
        'description': 'Brushed stainless steel mesh bracelet with sleek silver dial. Perfect companion for modern city lifestyle.',
        'price': 32000.0,
        'category': 'Casual',
        'image_path': 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=600&auto=format&fit=crop&q=80',
        'stock_quantity': 18,
      },
    ];

    for (var prod in demoProducts) {
      await db.insert('products', prod);
    }
  }

  // --- Product Operations ---
  Future<List<Product>> getProducts() async {
    final db = await database;
    final maps = await db.query('products');
    return maps.map((m) => Product.fromMap(m)).toList();
  }

  Future<Product?> getProductById(int id) async {
    final db = await database;
    final maps = await db.query('products', where: 'product_id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('products', product.toMap());
  }

  Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update(
      'products',
      product.toMap(),
      where: 'product_id = ?',
      whereArgs: [product.productId],
    );
  }

  Future<void> deleteProduct(int productId) async {
    final db = await database;
    await db.delete(
      'products',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  // --- Cart Operations ---
  Future<List<CartItem>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT c.*, p.name, p.description, p.price, p.category, p.image_path, p.stock_quantity
      FROM cart_items c
      JOIN products p ON c.product_id = p.product_id
    ''');

    List<CartItem> cartItems = [];
    for (var map in maps) {
      final cartItem = CartItem.fromMap(map);
      cartItem.product = Product.fromMap(map);
      cartItems.add(cartItem);
    }
    return cartItems;
  }

  Future<void> addToCart(int productId, int quantity, double unitPrice) async {
    final db = await database;
    final existing = await db.query(
      'cart_items',
      where: 'product_id = ?',
      whereArgs: [productId],
    );

    if (existing.isNotEmpty) {
      final currentQty = existing.first['quantity'] as int;
      final newQty = currentQty + quantity;
      await db.update(
        'cart_items',
        {'quantity': newQty, 'unit_price': unitPrice},
        where: 'product_id = ?',
        whereArgs: [productId],
      );
    } else {
      await db.insert('cart_items', {
        'product_id': productId,
        'quantity': quantity,
        'unit_price': unitPrice,
      });
    }
  }

  Future<void> updateCartQuantity(int cartId, int quantity) async {
    final db = await database;
    if (quantity <= 0) {
      await removeFromCart(cartId);
    } else {
      await db.update(
        'cart_items',
        {'quantity': quantity},
        where: 'cart_id = ?',
        whereArgs: [cartId],
      );
    }
  }

  Future<void> removeFromCart(int cartId) async {
    final db = await database;
    await db.delete('cart_items', where: 'cart_id = ?', whereArgs: [cartId]);
  }

  Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart_items');
  }

  // --- Profile Operations ---
  Future<UserProfile> getUserProfile() async {
    final db = await database;
    final maps = await db.query('user_profile', limit: 1);
    if (maps.isNotEmpty) {
      return UserProfile.fromMap(maps.first);
    }
    return UserProfile(name: 'Zeren Customer', email: 'customer@zeren.com', phoneNumber: '+923001234567', deliveryAddress: 'Islamabad');
  }

  Future<void> updateProfile(UserProfile profile) async {
    final db = await database;
    await db.update(
      'user_profile',
      profile.toMap(),
      where: 'user_id = ?',
      whereArgs: [profile.userId ?? 1],
    );
  }

  // --- Order Operations (Transaction based) ---
  Future<int> placeOrder(Order order, List<CartItem> cartItems) async {
    final db = await database;
    return await db.transaction((txn) async {
      // 1. Insert Order
      int orderId = await txn.insert('orders', order.toMap());

      // 2. Insert Order Items & Deduct Stock
      for (var item in cartItems) {
        await txn.insert('order_items', {
          'order_id': orderId,
          'product_id': item.productId,
          'product_name': item.product?.name ?? 'Watch',
          'quantity': item.quantity,
          'unit_price': item.unitPrice,
        });

        // Update product stock
        await txn.rawUpdate('''
          UPDATE products 
          SET stock_quantity = stock_quantity - ? 
          WHERE product_id = ?
        ''', [item.quantity, item.productId]);
      }

      // 3. Clear Cart
      await txn.delete('cart_items');

      return orderId;
    });
  }

  Future<List<Order>> getOrders() async {
    final db = await database;
    final orderMaps = await db.query('orders', orderBy: 'order_date DESC');
    List<Order> orders = [];

    for (var oMap in orderMaps) {
      final order = Order.fromMap(oMap);
      final itemMaps = await db.query(
        'order_items',
        where: 'order_id = ?',
        whereArgs: [order.orderId],
      );
      order.items = itemMaps.map((i) => OrderItem.fromMap(i)).toList();
      orders.add(order);
    }
    return orders;
  }

  // --- Database Backup & Restore Helpers ---
  Future<String> getDatabaseFilePath() async {
    final dbPath = await getDatabasesPath();
    return join(dbPath, 'zeren_watches.db');
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<void> reopenDatabase() async {
    _database = await _initDB('zeren_watches.db');
  }
}
