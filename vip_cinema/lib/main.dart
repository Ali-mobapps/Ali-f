import 'package:flutter/material.dart';

void main() {
  runApp(const CinemaApp());
}

class CinemaApp extends StatelessWidget {
  const CinemaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cinema Booking UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0E13), // Deep Cinematic Dark
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFE50914), // Cinematic Red Accent
          surface: const Color(0xFF1B1A22),
        ),
      ),
      home: const MovieHomeScreen(),
    );
  }
}

// ==================== SCREEN 1: MOVIES HOME ====================
class MovieHomeScreen extends StatelessWidget {
  const MovieHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('now showing', style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text('vip IMAX theater', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Color(0xFF1B1A22),
              child: Icon(Icons.movie, color: Color(0xFFE50914)),
            ),
            onPressed: () {
              // Navigate to Screen 2
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SeatBookingScreen()),
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
            // Promo Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF83050C), Color(0xFFE50914)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('imax premier premiere', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Interstellar: IMAX Re-Release\nBook VIP Recliner Seats Now', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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
                        MaterialPageRoute(builder: (context) => const SeatBookingScreen()),
                      );
                    },
                    child: const Text('book seats', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('trending movies', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SeatBookingScreen()),
                    );
                  },
                  child: const Text('view all ->', style: TextStyle(color: Color(0xFFE50914))),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Movie List Tiles
            const MovieTile(title: 'Interstellar (IMAX)', genre: 'Sci-Fi • Adventure', time: '09:00 PM', rating: '9.4'),
            const SizedBox(height: 10),
            const MovieTile(title: 'The Dark Knight', genre: 'Action • Crime • Drama', time: '06:30 PM', rating: '9.0'),
            const SizedBox(height: 10),
            const MovieTile(title: 'Inception VIP Cut', genre: 'Action • Sci-Fi • Thriller', time: '03:15 PM', rating: '8.8'),
          ],
        ),
      ),
    );
  }
}

// ==================== SCREEN 2: SEAT BOOKING & DETAILS ====================
class SeatBookingScreen extends StatelessWidget {
  const SeatBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('select vip seats', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE50914))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFE50914)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1A22),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Movie: Interstellar (IMAX)', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  SizedBox(height: 8),
                  Text('Screen 1 • VIP Recliner Box', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 4),
                  Text('Showtime: Today at 09:00 PM', style: TextStyle(color: Color(0xFFE50914), fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Selected Seats Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const SeatDetailRow(seat: 'Row F, Seat 12', type: 'VIP Recliner', price: '\$25.00'),
            const SizedBox(height: 8),
            const SeatDetailRow(seat: 'Row F, Seat 13', type: 'VIP Recliner', price: '\$25.00'),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Total Amount:', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text('\$50.00', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFE50914))),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50914),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('confirm booking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Widgets
class MovieTile extends StatelessWidget {
  final String title, genre, time, rating;

  const MovieTile({super.key, required this.title, required this.genre, required this.time, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1A22),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0E13),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_activity, color: Color(0xFFE50914)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text('$genre • $time', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 14),
              const SizedBox(width: 4),
              Text(rating, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class SeatDetailRow extends StatelessWidget {
  final String seat, type, price;

  const SeatDetailRow({super.key, required this.seat, required this.type, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1A22),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(seat, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text(type, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE50914), fontSize: 15)),
        ],
      ),
    );
  }
}