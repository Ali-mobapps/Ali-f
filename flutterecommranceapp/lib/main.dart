

import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const FoodApp());
}

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Ecommerce',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomeScreen(),
    );
  }
}

class FoodItem {
  final String name;
  final double price;
  final IconData icon;

  FoodItem({
    required this.name,
    required this.price,
    required this.icon,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final List<FoodItem> foods = [
    FoodItem(
      name: "Pizza",
      price: 12,
      icon: Icons.local_pizza,
    ),
    FoodItem(
      name: "Burger",
      price: 8,
      icon: Icons.lunch_dining,
    ),
    FoodItem(
      name: "Fries",
      price: 5,
      icon: Icons.fastfood,
    ),
    FoodItem(
      name: "Coffee",
      price: 4,
      icon: Icons.coffee,
    ),
    FoodItem(
      name: "Sandwich",
      price: 7,
      icon: Icons.breakfast_dining,
    ),
    FoodItem(
      name: "Cold Drink",
      price: 3,
      icon: Icons.local_drink,
    ),
  ];

  final List<FoodItem> cart = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Ecommerce"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          children: [

            TextField(
              decoration: InputDecoration(
                hintText: "Search Food",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: foods.length,
                itemBuilder: (context, index) {

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 4,

                    child: ListTile(

                      leading: Icon(
                        foods[index].icon,
                        size: 35,
                        color: Colors.orange,
                      ),

                      title: Text(
                        foods[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Text(
                        "\$${foods[index].price}",
                      ),

                      trailing: ElevatedButton(

                        onPressed: () {

                          setState(() {
                            cart.add(foods[index]);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${foods[index].name} Added",
                              ),
                            ),
                          );
                        },

                        child: const Text("Add"),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(cart: cart),
                    ),
                  );

                },

                child: const Text("Go To Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class CartScreen extends StatelessWidget {
  final List<FoodItem> cart;

  const CartScreen({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    double total = 0;

    for (var item in cart) {
      total += item.price;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          children: [

            Expanded(
              child: cart.isEmpty
                  ? const Center(
                child: Text(
                  "Cart is Empty",
                  style: TextStyle(fontSize: 20),
                ),
              )

                  : ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {

                  return Card(
                    child: ListTile(

                      leading: Icon(
                        cart[index].icon,
                        color: Colors.orange,
                      ),

                      title: Text(cart[index].name),

                      subtitle: Text(
                        "\$${cart[index].price}",
                      ),

                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Total Price : \$${total.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                onPressed: cart.isEmpty
                    ? null
                    : () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                        total: total,
                      ),
                    ),
                  );

                },

                child: const Text("Checkout"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class DetailsScreen extends StatefulWidget {
  final double total;

  const DetailsScreen({super.key, required this.total});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Details"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Total Bill : \$${widget.total.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  if (nameController.text.isEmpty ||
                      addressController.text.isEmpty ||
                      phoneController.text.isEmpty) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all fields"),
                      ),
                    );

                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ThankYouScreen(
                        name: nameController.text,
                        total: widget.total,
                      ),
                    ),
                  );
                },
                child: const Text("Place Order"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ThankYouScreen extends StatelessWidget {
  final String name;
  final double total;

  const ThankYouScreen({
    super.key,
    required this.name,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final int orderId = 1000 + Random().nextInt(9000);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Confirmation"),
        centerTitle: true,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),

              const SizedBox(height: 20),

              const Text(
                "Thank You!",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                "Dear $name,",
                style: const TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 10),

              const Text(
                "Your order has been placed successfully.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 20),

              Text(
                "Order ID : #$orderId",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                "Total Bill : \$${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {

                    Navigator.popUntil(
                      context,
                          (route) => route.isFirst,
                    );

                  },
                  child: const Text("Back To Home"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
