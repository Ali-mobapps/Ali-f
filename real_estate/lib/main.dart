import 'package:flutter/material.dart';

void main() {
  runApp(const RealEstateApp());
}

class RealEstateApp extends StatelessWidget {
  const RealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
      ),
      home: const RealEstateHomeScreen(),
    );
  }
}

class RealEstateHomeScreen extends StatefulWidget {
  const RealEstateHomeScreen({super.key});

  @override
  State<RealEstateHomeScreen> createState() => _RealEstateHomeScreenState();
}

class _RealEstateHomeScreenState extends State<RealEstateHomeScreen> with SingleTickerProviderStateMixin {
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
            Icon(Icons.home_work_rounded, color: Color(0xFF2563EB), size: 24),
            SizedBox(width: 8),
            Text('PrimeEstate Living', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none, color: Color(0xFF1E293B)),
              onPressed: () {},
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color(0xFF2563EB),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF64748B),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Explore Properties'),
                Tab(text: 'Saved & Visits'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ExplorePropertiesTab(),
          SavedVisitsTab(),
        ],
      ),
    );
  }
}

class ExplorePropertiesTab extends StatelessWidget {
  const ExplorePropertiesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search & Filter Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
            ),
            child: const TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: Color(0xFF64748B)),
                hintText: 'Search city, neighborhood, or villa...',
                hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Featured Listings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 12),
          SizedBox(
            height: 240,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                PropertyCard(title: 'Modern Glass Villa', location: 'Beverly Hills, CA', price: '\$1,450,000', beds: '4', baths: '3', color: Color(0xFF3B82F6)),
                SizedBox(width: 16),
                PropertyCard(title: 'Skyline Penthouse', location: 'Manhattan, NY', price: '\$2,100,000', beds: '3', baths: '3', color: Color(0xFF6366F1)),
                SizedBox(width: 16),
                PropertyCard(title: 'Cozy Suburban Home', location: 'Austin, TX', price: '\$680,000', beds: '5', baths: '4', color: Color(0xFF0EA5E9)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Nearby Recommended', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 12),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              PropertyTile(title: 'Sunset Ridge Apartment', location: 'Downtown Seattle', price: '\$450,000', specs: '2 Beds • 2 Baths • 1,100 sqft'),
              PropertyTile(title: 'Ocean Breeze Townhouse', location: 'San Diego, CA', price: '\$890,000', specs: '3 Beds • 3 Baths • 1,850 sqft'),
            ],
          ),
        ],
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final String title;
  final String location;
  final String price;
  final String beds;
  final String baths;
  final Color color;

  const PropertyCard({super.key, required this.title, required this.location, required this.price, required this.beds, required this.baths, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Icon(Icons.apartment, color: Colors.white, size: 36),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)), maxLines: 1),
              const SizedBox(height: 2),
              Text(location, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)), maxLines: 1),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB), fontSize: 13)),
              Text('$beds Beds • $baths Baths', style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
            ],
          ),
        ],
      ),
    );
  }
}

class PropertyTile extends StatelessWidget {
  final String title;
  final String location;
  final String price;
  final String specs;

  const PropertyTile({super.key, required this.title, required this.location, required this.price, required this.specs});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.house, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                const SizedBox(height: 2),
                Text(location, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                const SizedBox(height: 2),
                Text(specs, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
              ],
            ),
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB), fontSize: 14)),
        ],
      ),
    );
  }
}

class SavedVisitsTab extends StatelessWidget {
  const SavedVisitsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Scheduled Visits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month, color: Color(0xFF2563EB), size: 36),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Modern Glass Villa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B))),
                      SizedBox(height: 2),
                      Text('Tomorrow • 03:00 PM with Agent', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
                const Chip(
                  label: Text('Confirmed', style: TextStyle(color: Colors.white, fontSize: 11)),
                  backgroundColor: Colors.green,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Saved Wishlist', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 12),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              SavedPropertyTile(title: 'Skyline Penthouse', location: 'Manhattan, NY', price: '\$2,100,000'),
              SavedPropertyTile(title: 'Cozy Suburban Home', location: 'Austin, TX', price: '\$680,000'),
            ],
          ),
        ],
      ),
    );
  }
}

class SavedPropertyTile extends StatelessWidget {
  final String title;
  final String location;
  final String price;

  const SavedPropertyTile({super.key, required this.title, required this.location, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
      ),
      child: Row(
        children: [
          const Icon(Icons.favorite, color: Colors.redAccent),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                const SizedBox(height: 2),
                Text(location, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              ],
            ),
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB), fontSize: 14)),
        ],
      ),
    );
  }
}