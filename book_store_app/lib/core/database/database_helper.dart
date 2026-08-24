import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'book_store.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // ... existing fields and methods ...

  Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert('products', product);
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return await db.query('products');
  }

  Future<int> updateProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.update(
      'products',
      product,
      where: 'id = ?',
      whereArgs: [product['id']],
    );
  }

  Future<int> deleteProduct(String id) async {
    final db = await database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // POS Methods
  Future<void> createSale(Map<String, dynamic> sale, List<Map<String, dynamic>> items) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert('sales', sale);
      for (var item in items) {
        await txn.insert('sale_items', item);
        await txn.rawUpdate(
          'UPDATE products SET stock_quantity = stock_quantity - ? WHERE id = ?',
          [item['quantity'], item['product_id']]
        );
      }
    });
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. Unified Inventory
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT,
        type TEXT, -- 'book' or 'stationery'
        course_or_category TEXT, 
        rack_location TEXT,
        cost_price REAL,
        sale_price REAL,
        stock_quantity INTEGER,
        min_stock_threshold INTEGER DEFAULT 3
      )
    ''');

    // 2. Customers
    await db.execute('''
      CREATE TABLE customers (
        id TEXT PRIMARY KEY,
        name TEXT,
        phone TEXT,
        address TEXT
      )
    ''');

    // 3. Sales Header (Receipts)
    await db.execute('''
      CREATE TABLE sales (
        id TEXT PRIMARY KEY,
        customer_id TEXT,
        timestamp TEXT,
        total_amount REAL,
        discount REAL,
        final_amount REAL,
        FOREIGN KEY(customer_id) REFERENCES customers(id)
      )
    ''');

    // 4. Sale Items (Line items for receipt generation)
    await db.execute('''
      CREATE TABLE sale_items (
        id TEXT PRIMARY KEY,
        sale_id TEXT,
        product_id TEXT,
        quantity INTEGER,
        price_at_sale REAL,
        FOREIGN KEY(sale_id) REFERENCES sales(id),
        FOREIGN KEY(product_id) REFERENCES products(id)
      )
    ''');

    // 5. Ledger (Debt/Payments)
    await db.execute('''
      CREATE TABLE ledger_entries (
        id TEXT PRIMARY KEY,
        customer_id TEXT,
        amount REAL,
        type TEXT, -- 'credit' or 'payment'
        timestamp TEXT,
        FOREIGN KEY(customer_id) REFERENCES customers(id)
      )
    ''');
  }

  // Customer/Ledger Methods
  Future<int> insertCustomer(Map<String, dynamic> customer) async {
    final db = await database;
    return await db.insert('customers', customer);
  }

  Future<List<Map<String, dynamic>>> getCustomers() async {
    final db = await database;
    return await db.query('customers');
  }

  Future<int> insertLedgerEntry(Map<String, dynamic> entry) async {
    final db = await database;
    return await db.insert('ledger_entries', entry);
  }

  Future<List<Map<String, dynamic>>> getCustomerLedger(String customerId) async {
    final db = await database;
    return await db.query('ledger_entries', where: 'customer_id = ?', whereArgs: [customerId]);
  }

  // Insights Methods
  Future<List<Map<String, dynamic>>> getSales() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT s.*, SUM(si.quantity * (si.price_at_sale - p.cost_price)) as profit
      FROM sales s
      JOIN sale_items si ON s.id = si.sale_id
      JOIN products p ON si.product_id = p.id
      GROUP BY s.id
    ''');
  }

  Future<double> getTotalStockValue() async {
    final db = await database;
    final result = await db.rawQuery('SELECT SUM(cost_price * stock_quantity) as total FROM products');
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // In a real app, you would handle migrations here.
      // For now, we drop and recreate to ensure a clean slate for the new schema.
      await db.execute('DROP TABLE IF EXISTS inventory');
      await db.execute('DROP TABLE IF EXISTS sales');
      await db.execute('DROP TABLE IF EXISTS customers');
      await _onCreate(db, newVersion);
    }
  }
}
