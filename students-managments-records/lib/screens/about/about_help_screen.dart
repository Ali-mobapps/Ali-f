import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

class AboutHelpScreen extends StatelessWidget {
  const AboutHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About & Help Center'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Banner
            Card(
              color: AppColors.primaryNavy,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white12,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.school, size: 40, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.appName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Version ${AppConstants.appVersion}',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Features Card
            const Text(
              'Key Features',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.storage, color: AppColors.primaryLightBlue),
                      title: Text('Local SQLite Database'),
                      subtitle: Text('Full offline CRUD with unique roll number enforcement and indexed search.'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.cloud_sync, color: AppColors.primaryLightBlue),
                      title: Text('Google Drive Backup & Restore'),
                      subtitle: Text('Real cloud backup with replace and merge restore options.'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.security, color: AppColors.primaryLightBlue),
                      title: Text('Secure Local Authentication'),
                      subtitle: Text('Salted SHA-256 password hashing for admin accounts.'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.dashboard, color: AppColors.primaryLightBlue),
                      title: Text('Interactive Dashboard'),
                      subtitle: Text('Real-time statistics, department breakdown, and recent student records.'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Google Drive API Setup Guide
            const Text(
              'Google Drive API Setup Instructions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'To enable real Google Drive Cloud Backup & Restore on Android, follow these setup steps:',
                      style: TextStyle(fontSize: 13, height: 1.4),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '1. Go to Google Cloud Console (console.cloud.google.com).',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '2. Create or select a project and enable "Google Drive API".',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '3. Configure OAuth Consent Screen (User type: External/Internal).',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '4. Add Android OAuth 2.0 Client ID:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12, top: 4),
                      child: Text(
                        '• Package Name: com.example.students_managments_records\n'
                        '• SHA-1 Fingerprint: Get using `keytool -list -v -keystore ~/.android/debug.keystore`',
                        style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '5. Add Drive scopes: https://www.googleapis.com/auth/drive.appdata and drive.file.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // SQLite Schema Information
            const Text(
              'SQLite Database Schema',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Table: users', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryNavy)),
                    SizedBox(height: 4),
                    Text('id (PK), name, email (UNIQUE), password_hash, created_at', style: TextStyle(fontSize: 12)),
                    Divider(height: 20),
                    Text('Table: students', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryNavy)),
                    SizedBox(height: 4),
                    Text('id (PK), full_name, roll_number (UNIQUE), email, phone, department, semester, section, gender, address, cgpa, photo_path, created_at, updated_at', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
