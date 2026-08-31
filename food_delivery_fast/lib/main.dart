import 'package:flutter/material.dart';

void main() {
  runApp(const FoodDeliveryApp());
}

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFFBF9),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF6B6B)),
      ),
      home: const FoodHomeShell(),
    );
  }
}

class FoodHomeShell extends StatefulWidget {
  const FoodHomeShell({super.key});

  @override
  State<FoodHomeShell> createState() => _FoodHomeShellState();
}

class _FoodHomeShellState extends State<FoodHomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ExploreRestaurantsScreen(),
    CartCheckoutScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFFF6B6B).withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_outlined),
            selectedIcon: Icon(Icons.restaurant, color: Color(0xFFFF6B6B)),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag, color: Color(0xFFFF6B6B)),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFFFF6B6B)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ==================== SCREEN 1: EXPLORE RESTAURANTS ====================
class ExploreRestaurantsScreen extends StatelessWidget {
  const ExploreRestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.fastfood, color: Color(0xFFFF6B6B), size: 28),
                    SizedBox(width: 8),
                    Text('FlavorDash', style: TextStyle(color: Color(0xFF1F2937), fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Color(0xFFFF6B6B)),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('SPECIAL DISCOUNT', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text('50% Off on Pizza', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Use code: DASH50 at checkout', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  const Icon(Icons.local_pizza, color: Colors.white, size: 40),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Popular Restaurants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
            const SizedBox(height: 12),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                RestaurantTile(name: 'Burger Joint & Co.', cuisine: 'Fast Food • American', rating: '4.8', time: '20-30 mins'),
                RestaurantTile(name: 'Tokyo Sushi House', cuisine: 'Japanese • Seafood', rating: '4.9', time: '30-40 mins'),
                RestaurantTile(name: 'Trattoria Bella Italia', cuisine: 'Italian • Pasta', rating: '4.7', time: '25-35 mins'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantTile extends StatelessWidget {
  final String name;
  final String cuisine;
  final String rating;
  final String time;

  const RestaurantTile({super.key, required this.name, required this.cuisine, required this.rating, required this.time});

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
              color: const Color(0xFFFF6B6B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.storefront, color: Color(0xFFFF6B6B)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1F2937))),
                const SizedBox(height: 2),
                Text(cuisine, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 2),
                Text(time, style: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 14),
              const SizedBox(width: 2),
              Text(rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1F2937))),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== SCREEN 2: CART & CHECKOUT ====================
class CartCheckoutScreen extends StatelessWidget {
  const CartCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Order Cart', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
            const SizedBox(height: 16),
            const CartItemTile(item: 'Double Bacon Cheeseburger', price: '\$12.50', qty: '1'),
            const CartItemTile(item: 'Loaded Truffle Fries', price: '\$6.00', qty: '2'),
            const CartItemTile(item: 'Classic Vanilla Milkshake', price: '\$4.50', qty: '1'),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
              ),
              child: Column(
                children: const [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Subtotal', style: TextStyle(color: Colors.grey)), Text('\$29.50', style: TextStyle(fontWeight: FontWeight.bold))]),
                  SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Delivery Fee', style: TextStyle(color: Colors.grey)), Text('\$2.99', style: TextStyle(fontWeight: FontWeight.bold))]),
                  Divider(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text('\$32.49', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFFF6B6B)))]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final String item;
  final String price;
  final String qty;

  const CartItemTile({super.key, required this.item, required this.price, required this.qty});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1F2937))),
              const SizedBox(height: 2),
              Text('Qty: $qty', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6B6B), fontSize: 14)),
        ],
      ),
    );
  }
}

// ==================== SCREEN 3: USER PROFILE ====================
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Account & Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFFFF6B6B),
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  Text('Jessica Taylor', style: TextStyle(color: Color(0xFF1F2937), fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Gold Member • 14 Orders Placed', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const ProfileTile(icon: Icons.location_on, title: 'Delivery Addresses'),
            const ProfileTile(icon: Icons.local_offer, title: 'Vouchers & Promos'),
            const ProfileTile(icon: Icons.history, title: 'Order History'),
            const ProfileTile(icon: Icons.support_agent, title: 'Customer Support'),
          ],
        ),
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const ProfileTile({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFFF6B6B)),
        title: Text(title, style: const TextStyle(color: Color(0xFF1F2937), fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: () {},
      ),
    );
  }
}