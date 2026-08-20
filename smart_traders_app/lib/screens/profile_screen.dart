import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final theme = Theme.of(context);
    final metadata = user?.userMetadata;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF002D62),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text(
              metadata?['full_name'] ?? 'User Name',
              style: GoogleFonts.hankenGrotesk(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.email ?? 'email@example.com',
              style: GoogleFonts.hankenGrotesk(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            _buildProfileTile(Icons.business, 'Business Name', metadata?['full_name'] ?? 'Not set'),
            _buildProfileTile(Icons.email_outlined, 'Email', user?.email ?? 'Not set'),
            _buildProfileTile(Icons.phone_outlined, 'Phone', user?.phone ?? 'Add phone number'),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
              },
              icon: const Icon(Icons.logout),
              label: const Text('LOGOUT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC41E3A),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF002D62)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
