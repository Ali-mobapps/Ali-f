import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/product.dart';
import 'cart_screen.dart';

class MenuScreen extends StatefulWidget {
  final Student student;
  const MenuScreen({super.key, required this.student});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // LLO-3: Collections (Map for Menu Catalog)
  final Map<String, double> menuCatalog = {
    "Chicken Roll": 150.0,
    "Zinger Burger": 280.0,
    "Fries": 100.0,
    "Coffee": 120.0,
    "Fresh Juice": 180.0,
  };

  // Helper for icons
  final Map<String, String> menuIcons = {
    "Chicken Roll": "🌯",
    "Zinger Burger": "🍔",
    "Fries": "🍟",
    "Coffee": "☕",
    "Fresh Juice": "🍹",
  };

  // LLO-3: Collections (List for Order Selection)
  final List<String> cartItems = [];

  void _addToCart(String item) {
    setState(() {
      cartItems.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$item added to cart!"), duration: const Duration(milliseconds: 500)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Canteen Menu"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(
                        student: widget.student,
                        cartItems: cartItems,
                        menuCatalog: menuCatalog,
                      ),
                    ),
                  ).then((_) => setState(() {})); // Refresh count when coming back
                },
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text("${cartItems.length}", style: const TextStyle(fontSize: 10, color: Colors.white)),
                  ),
                )
            ],
          )
        ],
      ),
      body: Column(
        children: [
          // Student Info Header (Demonstrating String Interpolation)
          Container(
            padding: const EdgeInsets.all(15),
            color: Colors.teal.shade50,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome, ${widget.student.studentName} (${widget.student.studentId})", 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                Text("Wallet: Rs. ${widget.student.walletBalance.toStringAsFixed(2)}  |  Points: ${widget.student.loyaltyPoints}"),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: menuCatalog.length,
              itemBuilder: (context, index) {
                String itemName = menuCatalog.keys.elementAt(index);
                double price = menuCatalog.values.elementAt(index);
                return Card(
                  child: ListTile(
                    leading: Text(menuIcons[itemName] ?? "🍽️", style: const TextStyle(fontSize: 30)),
                    title: Text(itemName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Price: Rs. $price"),
                    trailing: ElevatedButton(
                      onPressed: () => _addToCart(itemName),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                      child: const Text("Add to Cart"),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
