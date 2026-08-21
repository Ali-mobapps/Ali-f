import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Inventory Table
    await db.execute('''
      CREATE TABLE inventory (
        id TEXT PRIMARY KEY,
        title TEXT,
        author TEXT,
        category TEXT,
        location TEXT,
        costPrice REAL,
        salePrice REAL,
        stockLevel INTEGER,
        minStockLevel INTEGER,
        isbn TEXT
      )
    ''');

    // Sales Table
    await db.execute('''
      CREATE TABLE sales (
        id TEXT PRIMARY KEY,
        dateTime TEXT,
        totalAmount REAL,
        customerName TEXT,
        status TEXT
      )
    ''');

    // Customers Table
    await db.execute('''
      CREATE TABLE customers (
        id TEXT PRIMARY KEY,
        name TEXT,
        phoneNumber TEXT,
        outstandingBalance REAL,
        lastTransactionDate TEXT
      )
    ''');
  }
}
