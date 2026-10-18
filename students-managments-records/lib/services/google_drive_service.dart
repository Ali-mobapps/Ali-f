import 'dart:convert';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class GoogleDriveBackupFile {
  final String id;
  final String name;
  final DateTime? createdTime;
  final int? size;

  GoogleDriveBackupFile({
    required this.id,
    required this.name,
    this.createdTime,
    this.size,
  });
}

class GoogleDriveService {
  static const List<String> requiredScopes = [
    drive.DriveApi.driveFileScope,
    drive.DriveApi.driveAppdataScope,
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: requiredScopes,
  );

  GoogleSignInAccount? _currentUser;

  GoogleSignInAccount? get currentUser => _currentUser;
  bool get isSignedIn => _currentUser != null;

  /// Silently attempts to sign in existing user
  Future<GoogleSignInAccount?> signInSilently() async {
    try {
      _currentUser = await _googleSignIn.signInSilently();
      if (_currentUser != null) {
        await _ensureScopes();
      }
      return _currentUser;
    } catch (_) {
      return null;
    }
  }

  /// Interactive Sign In flow
  Future<GoogleSignInAccount?> signIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      if (_currentUser != null) {
        await _ensureScopes();
      }
      return _currentUser;
    } catch (e) {
      rethrow;
    }
  }

  /// Ensures required Drive scopes are granted
  Future<void> _ensureScopes() async {
    if (_currentUser == null) return;
    final hasScopes = await _googleSignIn.canAccessScopes(requiredScopes);
    if (!hasScopes) {
      final granted = await _googleSignIn.requestScopes(requiredScopes);
      if (!granted) {
        throw Exception('Google Drive permissions were denied. Please grant Drive access.');
      }
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
    } catch (_) {
      _currentUser = null;
    }
  }

  /// Gets an authenticated Drive API client
  Future<drive.DriveApi> _getDriveApi() async {
    _currentUser ??= await signInSilently();
    if (_currentUser == null) {
      throw Exception('Google Account is not connected. Please sign in first.');
    }

    await _ensureScopes();

    final httpClient = await _googleSignIn.authenticatedClient();
    if (httpClient == null) {
      throw Exception('Failed to obtain authenticated Google HTTP client.');
    }

    return drive.DriveApi(httpClient);
  }

  /// Uploads backup JSON payload to Google Drive appDataFolder
  Future<String> uploadBackup(String jsonContent) async {
    try {
      final driveApi = await _getDriveApi();

      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
      final fileName = 'student_management_backup_$timestamp.json';

      final mediaContent = utf8.encode(jsonContent);
      final Stream<List<int>> stream = Stream.value(mediaContent);

      final driveFile = drive.File()
        ..name = fileName
        ..description = 'Student Management System Database Backup'
        ..parents = ['appDataFolder']
        ..mimeType = 'application/json';

      final media = drive.Media(stream, mediaContent.length);

      final uploadedFile = await driveApi.files.create(
        driveFile,
        uploadMedia: media,
        $fields: 'id, name, createdTime',
      );

      return uploadedFile.id ?? '';
    } catch (e) {
      throw Exception(_mapErrorMessage(e));
    }
  }

  /// Lists all available database backups in Drive appDataFolder
  Future<List<GoogleDriveBackupFile>> listBackups() async {
    try {
      final driveApi = await _getDriveApi();

      final fileList = await driveApi.files.list(
        spaces: 'appDataFolder',
        q: "name contains 'student_management_backup_' and mimeType = 'application/json'",
        orderBy: 'createdTime desc',
        $fields: 'files(id, name, createdTime, size)',
      );

      List<GoogleDriveBackupFile> backups = [];
      if (fileList.files != null) {
        for (var f in fileList.files!) {
          if (f.id != null && f.name != null) {
            backups.add(
              GoogleDriveBackupFile(
                id: f.id!,
                name: f.name!,
                createdTime: f.createdTime,
                size: f.size != null ? int.tryParse(f.size!) : null,
              ),
            );
          }
        }
      }

      return backups;
    } catch (e) {
      throw Exception(_mapErrorMessage(e));
    }
  }

  /// Downloads backup file content from Google Drive by File ID
  Future<String> downloadBackup(String fileId) async {
    try {
      final driveApi = await _getDriveApi();

      final drive.Media media = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      List<int> dataBytes = [];
      await for (var chunk in media.stream) {
        dataBytes.addAll(chunk);
      }

      return utf8.decode(dataBytes);
    } catch (e) {
      throw Exception(_mapErrorMessage(e));
    }
  }

  String _mapErrorMessage(dynamic error) {
    final str = error.toString();
    if (str.contains('401') || str.contains('Unauthorized')) {
      return 'Session expired. Please disconnect and reconnect your Google account.';
    }
    if (str.contains('403') || str.contains('Access Denied')) {
      return 'Access denied by Google Drive. Please check app permissions in Google Account settings.';
    }
    if (str.contains('SocketException') || str.contains('Failed host lookup')) {
      return 'Network error. Please check your internet connection.';
    }
    return str.replaceAll('Exception: ', '');
  }
}
