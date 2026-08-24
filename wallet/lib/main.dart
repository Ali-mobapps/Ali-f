import 'package:flutter/material.dart';

void main() {
  runApp(const CryptoWalletApp());
}

class CryptoWalletApp extends StatelessWidget {
  const CryptoWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Wallet UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0812), // Deep Web3 Charcoal
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF8B5CF6), // Neon Purple Accent
          surface: const Color(0xFF161325),
        ),
      ),
      home: const CryptoHomeScreen(),
    );
  }
}

// ==================== SCREEN 1: PORTFOLIO DASHBOARD ====================
class CryptoHomeScreen extends StatelessWidget {
  const CryptoHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('total balance', style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text('\$48,920.50', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Color(0xFF161325),
              child: Icon(Icons.account_balance_wallet, color: Color(0xFF8B5CF6)),
            ),
            onPressed: () {
              // Navigate to Screen 2
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TradeDetailScreen()),
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
            // Promo / Quick Action Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('staking rewards active', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Earn up to 14.5% APY\non Ethereum & Solana Vaults', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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
                        MaterialPageRoute(builder: (context) => const TradeDetailScreen()),
                      );
                    },
                    child: const Text('stake now', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('market assets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TradeDetailScreen()),
                    );
                  },
                  child: const Text('view all ->', style: TextStyle(color: Color(0xFF8B5CF6))),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Crypto Tiles
            const CryptoTile(name: 'Ethereum', symbol: 'ETH', price: '\$3,450.00', change: '+4.2%', isPositive: true),
            const SizedBox(height: 10),
            const CryptoTile(name: 'Bitcoin', symbol: 'BTC', price: '\$64,200.00', change: '-1.1%', isPositive: false),
            const SizedBox(height: 10),
            const CryptoTile(name: 'Solana', symbol: 'SOL', price: '\$148.50', change: '+8.7%', isPositive: true),
          ],
        ),
      ),
    );
  }
}

// ==================== SCREEN 2: TRADE & ASSET DETAILS ====================
class TradeDetailScreen extends StatelessWidget {
  const TradeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('asset performance', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF8B5CF6)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF161325),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ethereum (ETH / USD)', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  SizedBox(height: 8),
                  Text('\$3,450.00', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('24h High: \$3,510.00', style: TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.bold)),
                      Text('24h Vol: \$14.2B', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Transaction Analytics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const AnalyticsRow(label: 'Market Cap', value: '\$415.2 Billion'),
            const SizedBox(height: 8),
            const AnalyticsRow(label: 'Circulating Supply', value: '120.4M ETH'),
            const SizedBox(height: 8),
            const AnalyticsRow(label: 'All-Time High', value: '\$4,891.70'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('instant swap', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Widgets
class CryptoTile extends StatelessWidget {
  final String name, symbol, price, change;
  final bool isPositive;

  const CryptoTile({super.key, required this.name, required this.symbol, required this.price, required this.change, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161325),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0812),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.currency_bitcoin, color: Color(0xFF8B5CF6)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text(symbol, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(
                change,
                style: TextStyle(
                  color: isPositive ? Colors.greenAccent : Colors.redAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AnalyticsRow extends StatelessWidget {
  final String label, value;

  const AnalyticsRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF161325),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}