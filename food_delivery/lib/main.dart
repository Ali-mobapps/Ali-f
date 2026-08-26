import 'package:flutter/material.dart';

void main() {
  runApp(const FoodRecipeApp());
}

class FoodRecipeApp extends StatelessWidget {
  const FoodRecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFFDF9),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF6B35)),
      ),
      home: const FoodHomeScreen(),
    );
  }
}

class FoodHomeScreen extends StatefulWidget {
  const FoodHomeScreen({super.key});

  @override
  State<FoodHomeScreen> createState() => _FoodHomeScreenState();
}

class _FoodHomeScreenState extends State<FoodHomeScreen> with SingleTickerProviderStateMixin {
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
            Icon(Icons.restaurant_menu, color: Color(0xFFFF6B35), size: 24),
            SizedBox(width: 8),
            Text('Chef\'s Table & Recipes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
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
              icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF2D2D2D)),
              onPressed: () {},
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF5EBE6),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color(0xFFFF6B35),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF6D6D6D),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Discover Recipes'),
                Tab(text: 'My Kitchen & Cart'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          DiscoverRecipesTab(),
          KitchenCartTab(),
        ],
      ),
    );
  }
}

class DiscoverRecipesTab extends StatelessWidget {
  const DiscoverRecipesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFF9F1C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: const Color(0xFFFF6B35).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Special Offer', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    SizedBox(height: 4),
                    Text('50% OFF', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('On all Italian Wood-fired Pizzas', style: TextStyle(color: Colors.white, fontSize: 11)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.local_pizza, color: Colors.white, size: 36),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Popular Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                CategoryChip(label: 'Italian', icon: Icons.local_pizza, color: Colors.redAccent),
                SizedBox(width: 12),
                CategoryChip(label: 'Asian', icon: Icons.ramen_dining, color: Colors.orange),
                SizedBox(width: 12),
                CategoryChip(label: 'Desserts', icon: Icons.cake, color: Colors.pinkAccent),
                SizedBox(width: 12),
                CategoryChip(label: 'Drinks', icon: Icons.local_bar, color: Colors.blueAccent),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Top Rated Recipes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
          const SizedBox(height: 12),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              RecipeTile(title: 'Creamy Tuscan Garlic Chicken', time: '30 mins • 420 kcal', rating: '4.9', price: '\$14.50'),
              RecipeTile(title: 'Avocado & Quinoa Power Bowl', time: '15 mins • 310 kcal', rating: '4.8', price: '\$10.00'),
              RecipeTile(title: 'Classic Truffle Burger', time: '25 mins • 650 kcal', rating: '5.0', price: '\$16.20'),
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const CategoryChip({super.key, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF2D2D2D))),
        ],
      ),
    );
  }
}

class RecipeTile extends StatelessWidget {
  final String title;
  final String time;
  final String rating;
  final String price;

  const RecipeTile({super.key, required this.title, required this.time, required this.rating, required this.price});

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
              color: const Color(0xFFFF6B35).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.fastfood, color: Color(0xFFFF6B35)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2D2D2D))),
                const SizedBox(height: 3),
                Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6B35), fontSize: 14)),
              const SizedBox(height: 3),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 2),
                  Text(rating, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class KitchenCartTab extends StatelessWidget {
  const KitchenCartTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Active Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
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
                const Icon(Icons.delivery_dining, color: Color(0xFFFF6B35), size: 36),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('On the way', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2D2D2D))),
                      SizedBox(height: 2),
                      Text('Estimated arrival in 12 mins', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                const Text('\$24.50', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6B35), fontSize: 15)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Saved Shopping List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2D2D))),
          const SizedBox(height: 12),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              CartItemTile(item: 'Organic Olive Oil', quantity: '1 bottle', isBought: true),
              CartItemTile(item: 'Fresh Basil Leaves', quantity: '2 packets', isBought: false),
              CartItemTile(item: 'Parmesan Cheese Block', quantity: '250g', isBought: false),
            ],
          ),
        ],
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final String item;
  final String quantity;
  final bool isBought;

  const CartItemTile({super.key, required this.item, required this.quantity, required this.isBought});

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
          Icon(
            isBought ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isBought ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2D2D2D), decoration: isBought ? TextDecoration.lineThrough : null)),
                const SizedBox(height: 2),
                Text(quantity, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}