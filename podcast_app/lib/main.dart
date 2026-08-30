import 'package:flutter/material.dart';

void main() {
  runApp(const MusicApp());
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF09090B),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF10B981), brightness: Brightness.dark),
      ),
      home: const MusicHomeScreen(),
    );
  }
}

class MusicHomeScreen extends StatefulWidget {
  const MusicHomeScreen({super.key});

  @override
  State<MusicHomeScreen> createState() => _MusicHomeScreenState();
}

class _MusicHomeScreenState extends State<MusicHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.headset, color: Color(0xFF10B981), size: 24),
            SizedBox(width: 8),
            Text('VibeStream Audio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF18181B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white70),
              onPressed: () {},
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF18181B),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color(0xFF10B981),
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Music Library'),
                Tab(text: 'Podcasts & Shows'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          MusicLibraryTab(),
          PodcastsTab(),
        ],
      ),
    );
  }
}

class MusicLibraryTab extends StatelessWidget {
  const MusicLibraryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Now Playing Mini Player Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF047857)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: const Color(0xFF10B981).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.music_note, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Now Playing', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      SizedBox(height: 2),
                      Text('Midnight Sunset', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2),
                      Text('Lofi Chill Beats • 3:45', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.play_circle_filled, color: Colors.white, size: 40),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Recently Played', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                AlbumCard(title: 'Cyberpunk 2099', artist: 'Synthwave Matrix', color: Colors.purpleAccent),
                SizedBox(width: 12),
                AlbumCard(title: 'Acoustic Mornings', artist: 'Jane Doe', color: Colors.amberAccent),
                SizedBox(width: 12),
                AlbumCard(title: 'Deep Focus', artist: 'Ambient Minds', color: Colors.cyanAccent),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Your Favorite Tracks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              TrackTile(title: 'Electric Echoes', artist: 'Neon Pulse', duration: '3:20'),
              TrackTile(title: 'Starlight Odyssey', artist: 'Astral Plane', duration: '4:12'),
              TrackTile(title: 'Coffee & Rain', artist: 'Lofi Generator', duration: '2:55'),
            ],
          ),
        ],
      ),
    );
  }
}

class AlbumCard extends StatelessWidget {
  final String title;
  final String artist;
  final Color color;

  const AlbumCard({super.key, required this.title, required this.artist, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Icon(Icons.album, color: color, size: 32)),
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white), maxLines: 1),
          const SizedBox(height: 2),
          Text(artist, style: const TextStyle(color: Colors.grey, fontSize: 11), maxLines: 1),
        ],
      ),
    );
  }
}

class TrackTile extends StatelessWidget {
  final String title;
  final String artist;
  final String duration;

  const TrackTile({super.key, required this.title, required this.artist, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.play_arrow, color: Color(0xFF10B981), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                const SizedBox(height: 2),
                Text(artist, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(duration, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

class PodcastsTab extends StatelessWidget {
  const PodcastsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Trending Podcasts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              PodcastTile(title: 'Tech Founders Daily', host: 'Alex Rivers', episode: 'Ep. 142: Future of AI & UI Design', duration: '45 mins'),
              PodcastTile(title: 'Mind & Universe', host: 'Dr. Sarah Connor', episode: 'Ep. 89: Secrets of Deep Space', duration: '58 mins'),
              PodcastTile(title: 'Startup Growth Hacks', host: 'Mark Vance', episode: 'Ep. 22: Scaling to 1M Users', duration: '32 mins'),
            ],
          ),
        ],
      ),
    );
  }
}

class PodcastTile extends StatelessWidget {
  final String title;
  final String host;
  final String episode;
  final String duration;

  const PodcastTile({super.key, required this.title, required this.host, required this.episode, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.podcasts, color: Colors.indigoAccent),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                const SizedBox(height: 2),
                Text(episode, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 2),
                Text('Host: $host • $duration', style: const TextStyle(color: Color(0xFF10B981), fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}