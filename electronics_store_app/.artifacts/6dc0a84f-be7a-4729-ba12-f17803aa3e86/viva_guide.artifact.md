# ElectroStore Pro – Complete University Viva & Technical Guide

This document is your comprehensive preparation guide for your university midterm project viva. It covers the project architecture, frontend widgets, backend database, state management, security, and answers to common examiner questions.

---

## 1. Project Overview
- **App Name:** ElectroStore Pro (ElectroMart – Electronics Store)
- **Domain:** E-Commerce Mobile & Web Application for Electronics (Smartphones, Laptops, Headphones, Smartwatches, Tablets, Gaming & Computer Accessories).
- **Core Technologies:** Flutter, Dart, SQLite (`sqflite`), Provider State Management, Material 3, Google Sign-In & Google Drive API.

---

## 2. Tech Stack & Why Each Technology Was Used

| Technology | Purpose | Why It Was Used |
| :--- | :--- | :--- |
| **Flutter & Dart** | Frontend UI & Logic | Cross-platform capability (Android, iOS, Web, Desktop), high performance (Compiled to native machine code via Impeller), rich Material 3 widget library. |
| **SQLite (`sqflite`)** | Local Database (Backend) | Provides lightning-fast offline-first storage, relational tables with foreign keys, indexes, and ACID transaction support without needing an external cloud server for local demo. |
| **Provider (`provider`)** | State Management | Official recommended reactive state management. Separates business logic (`ChangeNotifier`) from UI widgets, triggering efficient UI rebuilds only when data changes. |
| **Google Sign-In & Drive API** | Cloud Backup & Restore | Allows users to securely authenticate via Google OAuth and store encrypted database backups privately in Google Drive's `appDataFolder`. |
| **Crypto (`crypto`)** | Security & Hashing | Computes SHA-256 cryptographic hashes of user passwords so plain-text passwords are never stored in the database. |

---

## 3. Frontend Architecture & Navigation

### Why `IndexedStack` and `NavigationBar` are Used:
In `lib/screens/main_navigation.dart`, we use a Material 3 `NavigationBar` combined with an `IndexedStack` containing the 5 main tabs:
1. **Home** (`HomeScreen`)
2. **Catalog** (`CatalogScreen`)
3. **Cart** (`CartScreen`)
4. **Orders** (`OrdersScreen`)
5. **Profile** (`ProfileScreen`)

**Why `IndexedStack` instead of normal navigation?**
- `IndexedStack` keeps all 5 child screens alive in memory simultaneously.
- When a user switches tabs (e.g., from Cart back to Home), the scroll position and state of each screen are **preserved** instead of being destroyed and reloaded from scratch. This delivers a smooth, native app experience like Daraz or Amazon.

---

## 4. Backend Architecture & Database (SQLite)

The database architecture follows a strict **Layered Architecture**:
1. **Models (`lib/models/`)**: Dart data classes (`UserModel`, `ProductModel`, `OrderModel`, etc.) with `toMap()` and `fromMap()` factory methods for serialization.
2. **Database Helper (`lib/database/database_helper.dart`)**: Manages SQLite connection, table creation (`_createDB`), versioning, and initial seeding (`_ensureSeeded`).
3. **Repositories (`lib/repositories/`)**: Encapsulates raw SQL queries (`AuthRepository`, `ProductRepository`, `CartRepository`, `OrderRepository`). Keeps SQL out of UI widgets.
4. **Providers (`lib/providers/`)**: Listens to repositories, holds application state, and calls `notifyListeners()` when data updates.

### Database Tables & Schema:
- **`users`**: Stores user ID, name, email (unique), password_hash, role (`customer` or `admin`), phone, address, created_at.
- **`categories`**: Stores product categories (Smartphones, Laptops, etc.) and category image URLs.
- **`products`**: Stores products with name, category, description, price, image_url, stock quantity, rating.
- **`cart_items`**: Stores items added to cart linked to `user_id` and `product_id`.
- **`wishlists`**: Stores favorite products saved by each user.
- **`orders`**: Stores checkout orders with order number, user ID, total amount, delivery fee, status (`Pending`, `Confirmed`, `Shipped`, `Delivered`, `Cancelled`), payment method, customer details.
- **`order_items`**: Stores a historical snapshot of purchased products, quantities, and prices so historical orders don't change if product prices are edited later.

---

## 5. How to Add Another Admin Email
If you want to add another administrator account or promote an existing user to admin, you can do it in two ways:

### Method A: Directly in Database Seeding (`lib/database/database_helper.dart`)
In `_ensureSeeded(Database db)` or `_seedInitialData(Database db)`, you can insert another admin user:
```dart
await db.insert('users', {
  'name': 'New Admin Name',
  'email': 'newadmin@electronics.com',
  'password_hash': hashPassword('securepassword123'),
  'role': 'admin', // <-- Set role to 'admin'
  'phone': '+923001234567',
  'address': 'Office, Lahore',
  'created_at': DateTime.now().toIso8601String(),
}, conflictAlgorithm: ConflictAlgorithm.ignore);
```

### Method B: Register via Signup and Update SQLite
1. Register a normal account through the app's **Sign Up** screen (e.g., `myadmin@gmail.com`).
2. Open your SQLite database viewer (or via admin query) and update their role:
   ```sql
   UPDATE users SET role = 'admin' WHERE email = 'myadmin@gmail.com';
   ```
   Now when `myadmin@gmail.com` logs in, `user.role == 'admin'` will evaluate to true, unlocking the full **Admin Dashboard** and product management tools!

---

## 6. Common Viva Questions & Model Answers

### Q1: Why did you use SQLite instead of Firebase or MySQL?
**Answer:** SQLite is an embedded, serverless, zero-configuration local database (`sqflite`). For a midterm offline-first mobile/desktop app, it provides high performance, data persistence across app restarts, and relational integrity via foreign keys without requiring an active internet connection or paid cloud server hosting.

### Q2: How is password security handled?
**Answer:** We **never** store plain-text passwords in the database. When a user registers or logs in, their password string is processed through the cryptographic **SHA-256 algorithm** (`crypto` package) to generate a secure 256-bit hexadecimal hash. Only this hash is compared against the database.

### Q3: What is State Management and why did you use Provider?
**Answer:** State management handles how data flows and updates across different screens. We used `Provider` (built on `InheritedWidget` and `ChangeNotifier`) because it is lightweight, officially recommended by Google, and cleanly separates UI widgets from business logic. When a user adds an item to the cart or places an order, the provider calls `notifyListeners()`, causing only the affected UI components to rebuild efficiently.

### Q4: How does Order Snapshotting work during Checkout?
**Answer:** When a customer places an order, we create entries in the `order_items` table storing the exact product name, price, and quantity at the time of purchase. This ensures that if an administrator later updates or increases product prices in the catalog, past customer orders remain historically accurate and unchanged.

### Q5: How does Google Drive Backup & Restore work?
**Answer:** The app exports all SQLite tables into a structured JSON file containing app version, timestamp, and all table rows. Using the authorized Google Drive API (`googleapis` and `google_sign_in`), the backup file is uploaded privately to the user's Google Drive **`appDataFolder`** (which keeps files hidden from ordinary drive files for privacy). During restoration, the JSON file is downloaded, parsed, and restored inside an atomic SQLite `transaction()` to guarantee database integrity.

---

### Good luck with your Viva! You've got this! 🎓🚀
