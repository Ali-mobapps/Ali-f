import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import '../database/database_helper.dart';

class GoogleDriveService {
  static final GoogleDriveService instance = GoogleDriveService._init();
  GoogleDriveService._init();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[drive.DriveApi.driveAppdataScope],
  );

  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  Future<GoogleSignInAccount?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      return account;
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Google Sign-Out Error: $e');
    }
  }

  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  // Export database to JSON string
  Future<String> exportDatabaseToJson() async {
    final db = await DatabaseHelper.instance.database;

    final users = await db.query('users');
    final categories = await db.query('categories');
    final products = await db.query('products');
    final cartItems = await db.query('cart_items');
    final wishlists = await db.query('wishlists');
    final orders = await db.query('orders');
    final orderItems = await db.query('order_items');

    final backupData = {
      'version': 1,
      'created_at': DateTime.now().toIso8601String(),
      'app': 'ElectroStore Pro',
      'tables': {
        'users': users,
        'categories': categories,
        'products': products,
        'cart_items': cartItems,
        'wishlists': wishlists,
        'orders': orders,
        'order_items': orderItems,
      },
    };

    return jsonEncode(backupData);
  }

  // Backup to Google Drive appDataFolder
  Future<String> backupToGoogleDrive() async {
    try {
      final account = _googleSignIn.currentUser ?? await signIn();
      if (account == null) {
        throw Exception('Google Sign-In aborted or failed.');
      }

      final authClient = await _googleSignIn.authenticatedClient();
      if (authClient == null) {
        throw Exception('Failed to obtain authenticated Google API client.');
      }

      final driveApi = drive.DriveApi(authClient);
      final jsonString = await exportDatabaseToJson();
      final bytes = utf8.encode(jsonString);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'electro_store_backup_$timestamp.json';

      final driveFile = drive.File()
        ..name = fileName
        ..parents = ['appDataFolder']
        ..mimeType = 'application/json';

      final media = drive.Media(Stream.value(bytes), bytes.length);

      final result = await driveApi.files.create(driveFile, uploadMedia: media);
      return result.id ?? 'Success';
    } catch (e) {
      debugPrint('Google Drive Backup Error: $e');
      rethrow;
    }
  }

  // List available backup files in Google Drive appDataFolder
  Future<List<Map<String, dynamic>>> listGoogleDriveBackups() async {
    try {
      final account = _googleSignIn.currentUser ?? await signIn();
      if (account == null) {
        throw Exception('Google Sign-In required to list backups.');
      }

      final authClient = await _googleSignIn.authenticatedClient();
      if (authClient == null) {
        throw Exception('Failed to obtain authenticated Google API client.');
      }

      final driveApi = drive.DriveApi(authClient);
      final fileList = await driveApi.files.list(
        spaces: 'appDataFolder',
        $fields: 'files(id, name, createdTime, size)',
      );

      final files = fileList.files ?? [];
      List<Map<String, dynamic>> backups = [];

      for (var file in files) {
        if (file.name != null && file.name!.startsWith('electro_store_backup_')) {
          backups.add({
            'id': file.id,
            'name': file.name,
            'createdTime': file.createdTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
            'size': file.size ?? '0',
          });
        }
      }

      // Sort by newest first
      backups.sort((a, b) => b['createdTime'].compareTo(a['createdTime']));
      return backups;
    } catch (e) {
      debugPrint('List Backups Error: $e');
      rethrow;
    }
  }

  // Restore database from Google Drive file ID
  Future<void> restoreFromGoogleDrive(String fileId) async {
    try {
      final authClient = await _googleSignIn.authenticatedClient();
      if (authClient == null) {
        throw Exception('Failed to obtain authenticated Google API client.');
      }

      final driveApi = drive.DriveApi(authClient);
      final media = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final bytesList = await media.stream.toList();
      final totalBytes = bytesList.expand((x) => x).toList();
      final jsonString = utf8.decode(totalBytes);

      await restoreDatabaseFromJson(jsonString);
    } catch (e) {
      debugPrint('Restore From Google Drive Error: $e');
      rethrow;
    }
  }

  // Restore database from JSON string with transaction safety
  Future<void> restoreDatabaseFromJson(String jsonString) async {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      if (!data.containsKey('tables') || !data.containsKey('version')) {
        throw Exception('Invalid backup file format.');
      }

      final tables = data['tables'] as Map<String, dynamic>;
      final db = await DatabaseHelper.instance.database;

      await db.transaction((txn) async {
        // Clear existing tables in correct order to respect foreign keys
        await txn.delete('order_items');
        await txn.delete('orders');
        await txn.delete('wishlists');
        await txn.delete('cart_items');
        await txn.delete('products');
        await txn.delete('categories');
        await txn.delete('users');

        // Restore users
        if (tables['users'] != null) {
          for (var row in tables['users']) {
            await txn.insert('users', Map<String, dynamic>.from(row));
          }
        }

        // Restore categories
        if (tables['categories'] != null) {
          for (var row in tables['categories']) {
            await txn.insert('categories', Map<String, dynamic>.from(row));
          }
        }

        // Restore products
        if (tables['products'] != null) {
          for (var row in tables['products']) {
            await txn.insert('products', Map<String, dynamic>.from(row));
          }
        }

        // Restore cart_items
        if (tables['cart_items'] != null) {
          for (var row in tables['cart_items']) {
            await txn.insert('cart_items', Map<String, dynamic>.from(row));
          }
        }

        // Restore wishlists
        if (tables['wishlists'] != null) {
          for (var row in tables['wishlists']) {
            await txn.insert('wishlists', Map<String, dynamic>.from(row));
          }
        }

        // Restore orders
        if (tables['orders'] != null) {
          for (var row in tables['orders']) {
            await txn.insert('orders', Map<String, dynamic>.from(row));
          }
        }

        // Restore order_items
        if (tables['order_items'] != null) {
          for (var row in tables['order_items']) {
            await txn.insert('order_items', Map<String, dynamic>.from(row));
          }
        }
      });
    } catch (e) {
      debugPrint('Restore Database Error: $e');
      rethrow;
    }
  }
}
