import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import '../database/database_helper.dart';

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}

class DriveBackupProvider with ChangeNotifier {
  bool _isBusy = false;
  String _statusMessage = 'Not connected to Google Drive';
  String? _lastBackupTime;
  GoogleSignInAccount? _currentUser;

  bool get isBusy => _isBusy;
  String get statusMessage => _statusMessage;
  String? get lastBackupTime => _lastBackupTime;
  bool get isSignedIn => _currentUser != null;
  String? get userEmail => _currentUser?.email;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveFileScope],
  );

  Future<void> signIn() async {
    try {
      _isBusy = true;
      _statusMessage = 'Signing in with Google...';
      notifyListeners();

      _currentUser = await _googleSignIn.signIn();
      if (_currentUser != null) {
        _statusMessage = 'Signed in as ${_currentUser!.email}';
      } else {
        _statusMessage = 'Sign in cancelled.';
      }
    } catch (e) {
      _statusMessage = 'Sign in failed: $e';
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
      _statusMessage = 'Signed out from Google Drive.';
      notifyListeners();
    } catch (e) {
      _statusMessage = 'Error signing out: $e';
      notifyListeners();
    }
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    if (_currentUser == null) {
      await signIn();
    }
    if (_currentUser == null) return null;

    final authHeaders = await _currentUser!.authHeaders;
    final client = GoogleAuthClient(authHeaders);
    return drive.DriveApi(client);
  }

  // --- Backup Database to Google Drive ---
  Future<bool> backupDatabase() async {
    try {
      _isBusy = true;
      _statusMessage = 'Preparing database backup...';
      notifyListeners();

      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        _statusMessage = 'Google Authentication required.';
        _isBusy = false;
        notifyListeners();
        return false;
      }

      // Get local db file path
      final dbPath = await DatabaseHelper.instance.getDatabaseFilePath();
      final dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        _statusMessage = 'Local database not found.';
        _isBusy = false;
        notifyListeners();
        return false;
      }

      _statusMessage = 'Uploading database to Google Drive...';
      notifyListeners();

      // Check if backup already exists on Drive
      String? existingFileId;
      final fileList = await driveApi.files.list(
        q: "name = 'zeren_watches_backup.db' and trashed = false",
      );

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        existingFileId = fileList.files!.first.id;
      }

      final media = drive.Media(dbFile.openRead(), await dbFile.length());
      final driveFile = drive.File();
      driveFile.name = 'zeren_watches_backup.db';
      driveFile.description = 'ZEREN Watches SQLite Database Backup';

      if (existingFileId != null) {
        // Update existing file
        await driveApi.files.update(driveFile, existingFileId, uploadMedia: media);
      } else {
        // Create new file
        await driveApi.files.create(driveFile, uploadMedia: media);
      }

      _lastBackupTime = DateTime.now().toString().substring(0, 19);
      _statusMessage = 'Backup successful! ($_lastBackupTime)';
      _isBusy = false;
      notifyListeners();
      return true;
    } catch (e) {
      _statusMessage = 'Backup failed: $e';
      _isBusy = false;
      notifyListeners();
      return false;
    }
  }

  // --- Restore Database from Google Drive ---
  Future<bool> restoreDatabase() async {
    try {
      _isBusy = true;
      _statusMessage = 'Connecting to Google Drive for restore...';
      notifyListeners();

      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        _statusMessage = 'Google Authentication required.';
        _isBusy = false;
        notifyListeners();
        return false;
      }

      _statusMessage = 'Searching for backup file...';
      notifyListeners();

      final fileList = await driveApi.files.list(
        q: "name = 'zeren_watches_backup.db' and trashed = false",
      );

      if (fileList.files == null || fileList.files!.isEmpty) {
        _statusMessage = 'No backup found on Google Drive.';
        _isBusy = false;
        notifyListeners();
        return false;
      }

      final fileId = fileList.files!.first.id!;
      _statusMessage = 'Downloading backup file...';
      notifyListeners();

      // Download file stream
      final drive.Media media = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final dbPath = await DatabaseHelper.instance.getDatabaseFilePath();
      final dbFile = File(dbPath);

      // Create local recovery backup before replacing
      if (await dbFile.exists()) {
        final recoveryPath = '$dbPath.recovery';
        await dbFile.copy(recoveryPath);
      }

      // Close current DB connection
      await DatabaseHelper.instance.closeDatabase();

      // Write downloaded bytes to local db path
      final List<int> dataBytes = [];
      await for (var chunk in media.stream) {
        dataBytes.addAll(chunk);
      }
      await dbFile.writeAsBytes(dataBytes);

      // Reopen database
      await DatabaseHelper.instance.reopenDatabase();

      _statusMessage = 'Database restored successfully!';
      _isBusy = false;
      notifyListeners();
      return true;
    } catch (e) {
      _statusMessage = 'Restore failed: $e';
      _isBusy = false;
      notifyListeners();
      return false;
    }
  }

  // --- Delete Backup from Google Drive ---
  Future<bool> deleteDriveBackup() async {
    try {
      _isBusy = true;
      _statusMessage = 'Searching for backup on Google Drive...';
      notifyListeners();

      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        _statusMessage = 'Google Authentication required.';
        _isBusy = false;
        notifyListeners();
        return false;
      }

      final fileList = await driveApi.files.list(
        q: "name = 'zeren_watches_backup.db' and trashed = false",
      );

      if (fileList.files == null || fileList.files!.isEmpty) {
        _statusMessage = 'No backup found on Google Drive to delete.';
        _isBusy = false;
        notifyListeners();
        return false;
      }

      final fileId = fileList.files!.first.id!;
      _statusMessage = 'Deleting backup from Google Drive...';
      notifyListeners();

      await driveApi.files.delete(fileId);

      _lastBackupTime = null;
      _statusMessage = 'Backup deleted from Google Drive successfully!';
      _isBusy = false;
      notifyListeners();
      return true;
    } catch (e) {
      _statusMessage = 'Failed to delete backup: $e';
      _isBusy = false;
      notifyListeners();
      return false;
    }
  }
}
