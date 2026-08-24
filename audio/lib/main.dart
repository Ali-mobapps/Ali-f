import 'package:flutter/material.dart';

void main() {
  runApp(const MusicPlayerApp());
}

class MusicPlayerApp extends StatelessWidget {
  const MusicPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VIP Music Streaming',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A090C), // Deep Audio Night
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFE11D48), // Neon Crimson Pink
          surface: const Color(0xFF16141B),
        ),
      ),
      home: const MusicHomeScreen(),
    );
  }
}

// ==================== SCREEN 1: MUSIC DISCOVER DASHBOARD ====================
class MusicHomeScreen extends StatelessWidget {
  const MusicHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('streaming in hi-res', style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text('vip audio lounge', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Color(0xFF16141B),
              child: Icon(Icons.headphones, color: Color(0xFFE11D48)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NowPlayingScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Artist Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF881337), Color(0xFFE11D48)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('lossless master audio', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Cyberpunk 2077 OST\nDolby Atmos Spatial Mix', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NowPlayingScreen()),
                      );
                    },
                    child: const Text('listen now', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('trending playlists', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Horizontal Playlist Cards
            SizedBox(
              height: 130,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  PlaylistCard(title: 'Synthwave Dark', subtitle: '24 Tracks'),
                  SizedBox(width: 12),
                  PlaylistCard(title: 'Lo-Fi Night Session', subtitle: '40 Tracks'),
                  SizedBox(width: 12),
                  PlaylistCard(title: 'Epic Orchestral', subtitle: '18 Tracks'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('recent hits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            const SongTile(title: 'Neon Horizon', artist: 'Kavinsky VIP', duration: '3:45'),
            const SizedBox(height: 10),
            const SongTile(title: 'Starlight Odyssey', artist: 'M83 Horizon', duration: '4:12'),
            const SizedBox(height: 10),
            const SongTile(title: 'Midnight Runner', artist: 'The Midnight', duration: '5:01'),
          ],
        ),
      ),
    );
  }
}

// ==================== SCREEN 2: NOW PLAYING & EQUALIZER ====================
class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('now playing', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE11D48))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFE11D48)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Vinyl Record Art Simulation
            Center(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF16141B),
                  border: Border.all(color: const Color(0xFFE11D48), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE11D48).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFF881337),
                    child: Icon(Icons.music_note, size: 40, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Neon Horizon', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            const Text('Kavinsky VIP • 24-bit / 192kHz', style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 24),

            // Track Progress Bar
            const LinearProgressIndicator(
              value: 0.45,
              backgroundColor: Color(0xFF16141B),
              color: Color(0xFFE11D48),
              minHeight: 6,
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('1:42', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text('3:45', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 20),

            // Playback Controls
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shuffle, color: Colors.grey, size: 24),
                SizedBox(width: 32),
                Icon(Icons.skip_previous, color: Colors.white, size: 36),
                SizedBox(width: 32),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFFE11D48),
                  child: Icon(Icons.pause, color: Colors.white, size: 32),
                ),
                SizedBox(width: 32),
                Icon(Icons.skip_next, color: Colors.white, size: 36),
                SizedBox(width: 32),
                Icon(Icons.repeat, color: Colors.grey, size: 24),
              ],
            ),
            const Spacer(),

            // Back Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE11D48),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('back to library', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Widgets
class PlaylistCard extends StatelessWidget {
  final String title, subtitle;

  const PlaylistCard({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF16141B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.album, color: Color(0xFFE11D48), size: 32),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}

class SongTile extends StatelessWidget {
  final String title, artist, duration;

  const SongTile({super.key, required this.title, required this.artist, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF16141B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.play_circle_fill, color: Color(0xFFE11D48), size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(artist, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(duration, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}