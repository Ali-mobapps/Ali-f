import 'package:flutter/material.dart';

void main() {
  runApp(const RecipeBookApp());
}

class RecipeBookApp extends StatelessWidget {
  const RecipeBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFFBEB),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD97706)),
      ),
      home: const RecipeHomeShell(),
    );
  }
}

class RecipeHomeShell extends StatefulWidget {
  const RecipeHomeShell({super.key});

  @override
  State<RecipeHomeShell> createState() => _RecipeHomeShellState();
}

class _RecipeHomeShellState extends State<RecipeHomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ExploreRecipesScreen(),
    SavedFavoritesScreen(),
    ChefProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFD97706).withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu, color: Color(0xFFD97706)),
            label: 'Recipes',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border),
            selectedIcon: Icon(Icons.bookmark, color: Color(0xFFD97706)),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFFD97706)),
            label: 'Chef',
          ),
        ],
      ),
    );
  }
}

// ==================== SCREEN 1: EXPLORE RECIPES ====================
class ExploreRecipesScreen extends StatelessWidget {
  const ExploreRecipesScreen({super.key});

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
                    Icon(Icons.soup_kitchen, color: Color(0xFFD97706), size: 28),
                    SizedBox(width: 8),
                    Text('TasteCraft', style: TextStyle(color: Color(0xFF78350F), fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Color(0xFFD97706)),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB45309), Color(0xFFD97706)],
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
                      Text('CHEF OF THE WEEK', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                      SizedBox(height: 6),
                      Text('Master Italian Pasta', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('20 mins • Easy • 4.9 Rating', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  const Icon(Icons.local_dining, color: Colors.white, size: 40),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Trending Recipes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF78350F))),
            const SizedBox(height: 12),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                RecipeTile(title: 'Creamy Garlic Mushroom Pasta', category: 'Italian • Dinner', time: '25 mins', calories: '420 kcal'),
                RecipeTile(title: 'Avocado & Poached Egg Toast', category: 'Breakfast • Healthy', time: '10 mins', calories: '280 kcal'),
                RecipeTile(title: 'Teriyaki Glazed Salmon', category: 'Japanese • Seafood', time: '30 mins', calories: '510 kcal'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeTile extends StatelessWidget {
  final String title;
  final String category;
  final String time;
  final String calories;

  const RecipeTile({super.key, required this.title, required this.category, required this.time, required this.calories});

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
              color: const Color(0xFFD97706).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.fastfood, color: Color(0xFFD97706)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF78350F))),
                const SizedBox(height: 2),
                Text(category, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 2),
                Text('$time • $calories', style: const TextStyle(color: Color(0xFFD97706), fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Icon(Icons.bookmark_border, color: Color(0xFFD97706)),
        ],
      ),
    );
  }
}

// ==================== SCREEN 2: SAVED FAVORITES ====================
class SavedFavoritesScreen extends StatelessWidget {
  const SavedFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Saved Recipes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF78350F))),
            SizedBox(height: 16),
            FavoriteRecipeTile(title: 'Creamy Garlic Mushroom Pasta', prepTime: '25 mins'),
            FavoriteRecipeTile(title: 'Teriyaki Glazed Salmon', prepTime: '30 mins'),
          ],
        ),
      ),
    );
  }
}

class FavoriteRecipeTile extends StatelessWidget {
  final String title;
  final String prepTime;

  const FavoriteRecipeTile({super.key, required this.title, required this.prepTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF78350F))),
              const SizedBox(height: 4),
              Text('Prep time: $prepTime', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const Icon(Icons.bookmark, color: Color(0xFFD97706)),
        ],
      ),
    );
  }
}

// ==================== SCREEN 3: CHEF PROFILE ====================
class ChefProfileScreen extends StatelessWidget {
  const ChefProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chef Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF78350F))),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFFD97706),
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  Text('Chef Gordon', style: TextStyle(color: Color(0xFF78350F), fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Executive Chef • 42 Published Recipes', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const ProfileMenuTile(icon: Icons.menu_book, title: 'My Published Recipes'),
            const ProfileMenuTile(icon: Icons.shopping_cart, title: 'Grocery Shopping List'),
            const ProfileMenuTile(icon: Icons.star_rate, title: 'Reviews & Ratings'),
            const ProfileMenuTile(icon: Icons.settings, title: 'Account Settings'),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const ProfileMenuTile({super.key, required this.icon, required this.title});

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
        leading: Icon(icon, color: const Color(0xFFD97706)),
        title: Text(title, style: const TextStyle(color: Color(0xFF78350F), fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: () {},
      ),
    );
  }
}