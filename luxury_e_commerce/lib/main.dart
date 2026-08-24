import 'package:flutter/material.dart';

void main() {
  runApp(const LuxuryFashionApp());
}

class LuxuryFashionApp extends StatelessWidget {
  const LuxuryFashionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luxury Fashion UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0E11), // Deep Velvet Dark
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFE2B714), // Champagne Gold Accent
          surface: const Color(0xFF1A181D),
        ),
      ),
      home: const FashionHomeScreen(),
    );
  }
}

// ==================== SCREEN 1: BOUTIQUE HOME ====================
class FashionHomeScreen extends StatelessWidget {
  const FashionHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('collection 2026', style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text('milan couture vip', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Color(0xFF1A181D),
              child: Icon(Icons.shopping_bag_outlined, color: Color(0xFFE2B714)),
            ),
            onPressed: () {
              // Navigate to Screen 2
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartDetailScreen()),
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
                  colors: [Color(0xFF8A720C), Color(0xFFE2B714)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('vip private sale', style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Spring-Summer Velvet Edition\nExclusive Runway Access', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: const Color(0xFFE2B714),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartDetailScreen()),
                      );
                    },
                    child: const Text('explore boutique', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('featured arrivals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartDetailScreen()),
                    );
                  },
                  child: const Text('view bag ->', style: TextStyle(color: Color(0xFFE2B714))),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Product Tiles
            const ProductTile(name: 'Italian Wool Overcoat', category: 'Outerwear • Midnight Black', price: '\$890.00'),
            const SizedBox(height: 10),
            const ProductTile(name: 'Silk Evening Tuxedo', category: 'Formal Wear • Charcoal', price: '\$1,450.00'),
            const SizedBox(height: 10),
            const ProductTile(name: 'Handcrafted Leather Oxford Shoes', category: 'Footwear • Espresso', price: '\$420.00'),
          ],
        ),
      ),
    );
  }
}

// ==================== SCREEN 2: CART & CHECKOUT DETAILS ====================
class CartDetailScreen extends StatelessWidget {
  const CartDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('shopping bag summary', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE2B714))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFE2B714)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A181D),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Delivery Address', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  SizedBox(height: 8),
                  Text('Penthouse 4B, Grand Towers, Downtown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Courier: VIP Express', style: TextStyle(color: Color(0xFFE2B714), fontWeight: FontWeight.bold)),
                      Text('Free Shipping', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Bag Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const BagItemRow(item: 'Italian Wool Overcoat', size: 'Size: L', price: '\$890.00'),
            const SizedBox(height: 8),
            const BagItemRow(item: 'Handcrafted Leather Oxfords', size: 'Size: 42', price: '\$420.00'),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Total Amount:', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text('\$1,310.00', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFE2B714))),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE2B714),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('proceed to secure checkout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Widgets
class ProductTile extends StatelessWidget {
  final String name, category, price;

  const ProductTile({super.key, required this.name, required this.category, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A181D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0E11),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.checkroom, color: Color(0xFFE2B714)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text(category, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE2B714), fontSize: 14)),
        ],
      ),
    );
  }
}

class BagItemRow extends StatelessWidget {
  final String item, size, price;

  const BagItemRow({super.key, required this.item, required this.size, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A181D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text(size, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE2B714), fontSize: 15)),
        ],
      ),
    );
  }
}