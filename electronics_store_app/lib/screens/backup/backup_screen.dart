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
  List<Map<String, dynamic>> _cloudBackups = [];
  List<Map<String, dynamic>> _localBackups = [];
  bool _fetchingBackups = false;
  bool _isGoogleTab = false; // Toggle between Local Device Backup and Google Drive

  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
    _fetchLocalBackups();
  }

  Future<void> _checkSignInStatus() async {
    try {
      final signedIn = await GoogleDriveService.instance.isSignedIn();
      if (signedIn) {
        setState(() {
          _currentUser = GoogleDriveService.instance.currentUser;
        });
        _fetchCloudBackups();
      }
    } catch (_) {}
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Connecting to Google Account...';
    });

    try {
      final account = await GoogleDriveService.instance.signIn();
      setState(() {
        _currentUser = account;
        _statusMessage = 'Signed in successfully as ${account?.email}';
      });
      _fetchCloudBackups();
    } catch (e) {
      setState(() {
        _statusMessage = 'Google Sign-In Note: ApiException: 10 occurs if SHA-1 is unconfigured in Google Console. Use Local Device Backup below for instant offline testing!';
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
        _cloudBackups = [];
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

  Future<void> _backupToDevice() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Creating local device backup...';
    });

    try {
      final path = await GoogleDriveService.instance.backupToDeviceLocal();
      setState(() {
        _statusMessage = 'Local backup saved successfully!\nPath: $path';
      });
      _fetchLocalBackups();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Local backup created successfully!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Local backup failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _backupToGoogleDrive() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Uploading database to Google Drive appDataFolder...';
    });

    try {
      await GoogleDriveService.instance.backupToGoogleDrive();
      setState(() {
        _statusMessage = 'Google Drive backup uploaded successfully!';
      });
      _fetchCloudBackups();
    } catch (e) {
      setState(() {
        _statusMessage = 'Google Drive upload failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchLocalBackups() async {
    setState(() {
      _fetchingBackups = true;
    });
    try {
      final list = await GoogleDriveService.instance.listLocalBackups();
      setState(() {
        _localBackups = list;
      });
    } catch (e) {
      debugPrint('Fetch local backups error: $e');
    } finally {
      setState(() {
        _fetchingBackups = false;
      });
    }
  }

  Future<void> _fetchCloudBackups() async {
    setState(() {
      _fetchingBackups = true;
    });

    try {
      final list = await GoogleDriveService.instance.listGoogleDriveBackups();
      setState(() {
        _cloudBackups = list;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Failed to fetch cloud backups: $e';
      });
    } finally {
      setState(() {
        _fetchingBackups = false;
      });
    }
  }

  Future<void> _confirmRestoreLocal(String filePath, String fileName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Local Backup?'),
        content: Text('Are you sure you want to restore from "$fileName"? This will replace current store data with backup data.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
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
        _statusMessage = 'Restoring database from local file...';
      });

      try {
        await GoogleDriveService.instance.restoreFromLocalFile(filePath);
        setState(() {
          _statusMessage = 'Database restored successfully from local backup!';
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

  Future<void> _confirmRestoreCloud(String fileId, String fileName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Cloud Backup?'),
        content: Text('Are you sure you want to restore from "$fileName"? This will replace current store data.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
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
        _statusMessage = 'Downloading and restoring cloud backup...';
      });

      try {
        await GoogleDriveService.instance.restoreFromGoogleDrive(fileId);
        setState(() {
          _statusMessage = 'Database restored successfully from Google Drive!';
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
        title: const Text('Backup & Restore'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: !_isGoogleTab ? const Color(0xFF2563EB) : Colors.transparent,
                      foregroundColor: !_isGoogleTab ? Colors.white : Colors.black87,
                      shape: const RoundedRectangleBorder(),
                    ),
                    onPressed: () => setState(() => _isGoogleTab = false),
                    child: const Text('Local Device Backup', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: _isGoogleTab ? const Color(0xFF2563EB) : Colors.transparent,
                      foregroundColor: _isGoogleTab ? Colors.white : Colors.black87,
                      shape: const RoundedRectangleBorder(),
                    ),
                    onPressed: () => setState(() => _isGoogleTab = true),
                    child: const Text('Google Drive Cloud', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_isGoogleTab) ...[
              // Local Backup Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(Icons.storage, size: 50, color: Color(0xFF2563EB)),
                      const SizedBox(height: 12),
                      const Text(
                        'Local Device Backup & Restore',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Instantly backup and restore your SQLite store database locally on your device without needing Google Cloud credentials.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.save),
                        label: const Text('Create Local Backup Now'),
                        onPressed: _isLoading ? null : _backupToDevice,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Local Backups on Device', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Color(0xFF2563EB)),
                    onPressed: _fetchingBackups ? null : _fetchLocalBackups,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_localBackups.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(child: Text('No local backups found. Create one above!', style: TextStyle(color: Color(0xFF64748B)))),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _localBackups.length,
                  itemBuilder: (context, index) {
                    final backup = _localBackups[index];
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
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white),
                          onPressed: _isLoading ? null : () => _confirmRestoreLocal(backup['id'], backup['name']),
                          child: const Text('Restore'),
                        ),
                      ),
                    );
                  },
                ),
            ] else ...[
              // Google Drive Cloud Section
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
                        _currentUser != null ? 'Connected to Google Drive' : 'Google Cloud Sign-In',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _currentUser?.email ?? 'Note: Google Sign-In requires SHA-1 fingerprint configured in Google Cloud Console. If you see ApiException: 10, use Local Device Backup.',
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
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.backup),
                  label: const Text('Upload Backup to Google Drive', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: _isLoading ? null : _backupToGoogleDrive,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Cloud Backups', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Color(0xFF2563EB)),
                      onPressed: _fetchingBackups ? null : _fetchCloudBackups,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_fetchingBackups)
                  const Center(child: CircularProgressIndicator())
                else if (_cloudBackups.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Center(child: Text('No cloud backups found in Drive appDataFolder.', style: TextStyle(color: Color(0xFF64748B)))),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _cloudBackups.length,
                    itemBuilder: (context, index) {
                      final backup = _cloudBackups[index];
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
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white),
                            onPressed: _isLoading ? null : () => _confirmRestoreCloud(backup['id'], backup['name']),
                            child: const Text('Restore'),
                          ),
                        ),
                      );
                    },
                  ),
              ],
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
