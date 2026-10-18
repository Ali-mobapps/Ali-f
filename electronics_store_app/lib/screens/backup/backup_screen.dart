import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../services/google_drive_service.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  bool _isLoading = false;
  String _statusMessage = '';
  GoogleSignInAccount? _currentUser;
  List<Map<String, dynamic>> _backups = [];
  bool _fetchingBackups = false;

  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
  }

  Future<void> _checkSignInStatus() async {
    final signedIn = await GoogleDriveService.instance.isSignedIn();
    if (signedIn) {
      setState(() {
        _currentUser = GoogleDriveService.instance.currentUser;
      });
      _fetchBackups();
    }
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Signing in with Google...';
    });

    try {
      final account = await GoogleDriveService.instance.signIn();
      setState(() {
        _currentUser = account;
        _statusMessage = 'Signed in successfully as ${account?.email}';
      });
      _fetchBackups();
    } catch (e) {
      setState(() {
        _statusMessage = 'Sign-in failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Signing out...';
    });

    try {
      await GoogleDriveService.instance.signOut();
      setState(() {
        _currentUser = null;
        _backups = [];
        _statusMessage = 'Signed out successfully.';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Sign-out error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _backupNow() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Creating database backup and uploading to Google Drive...';
    });

    try {
      await GoogleDriveService.instance.backupToGoogleDrive();
      setState(() {
        _statusMessage = 'Backup uploaded successfully to Google Drive appDataFolder!';
      });
      _fetchBackups();
    } catch (e) {
      setState(() {
        _statusMessage = 'Backup failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchBackups() async {
    setState(() {
      _fetchingBackups = true;
    });

    try {
      final list = await GoogleDriveService.instance.listGoogleDriveBackups();
      setState(() {
        _backups = list;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to fetch backups: $e';
      });
    } finally {
      setState(() {
        _fetchingBackups = false;
      });
    }
  }

  Future<void> _confirmRestore(String fileId, String fileName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Database?'),
        content: Text(
          'Are you sure you want to restore from "$fileName"? This will replace all current local data with the backup data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Restore', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
        _statusMessage = 'Downloading and restoring database...';
      });

      try {
        await GoogleDriveService.instance.restoreFromGoogleDrive(fileId);
        setState(() {
          _statusMessage = 'Database restored successfully! Please restart the app or refresh data.';
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Database restored successfully!'), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        setState(() {
          _statusMessage = 'Restore failed: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Drive Backup & Restore'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Account Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_sync, size: 50, color: Color(0xFF2563EB)),
                    const SizedBox(height: 12),
                    Text(
                      _currentUser != null ? 'Connected to Google Drive' : 'Not Connected',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _currentUser?.email ?? 'Sign in to backup and restore your store database securely.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 20),
                    if (_currentUser == null)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.login),
                        label: const Text('Connect Google Account'),
                        onPressed: _isLoading ? null : _signIn,
                      )
                    else
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.logout),
                        label: const Text('Disconnect Account'),
                        onPressed: _isLoading ? null : _signOut,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            if (_currentUser != null) ...[
              // Backup Now Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.backup),
                label: const Text('Backup Now (Upload to Drive)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: _isLoading ? null : _backupNow,
              ),
              const SizedBox(height: 24),

              // Backups List Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available Cloud Backups',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Color(0xFF2563EB)),
                    onPressed: _fetchingBackups ? null : _fetchBackups,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (_fetchingBackups)
                const Center(child: CircularProgressIndicator())
              else if (_backups.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Text(
                      'No backups found in Google Drive appDataFolder.',
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _backups.length,
                  itemBuilder: (context, index) {
                    final backup = _backups[index];
                    final dateStr = backup['createdTime'] ?? '';
                    final formattedDate = dateStr.length > 16 ? dateStr.substring(0, 16).replaceAll('T', ' ') : dateStr;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: const Icon(Icons.insert_drive_file, color: Color(0xFF2563EB)),
                        title: Text(backup['name'] ?? 'Backup', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Created: $formattedDate'),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _isLoading ? null : () => _confirmRestore(backup['id'], backup['name']),
                          child: const Text('Restore'),
                        ),
                      ),
                    );
                  },
                ),
            ],

            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_statusMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF1E3A8A)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
