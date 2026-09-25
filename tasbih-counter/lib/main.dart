import 'package:flutter/material.dart';

void main() {
  runApp(const TasbheeApp());
}

// =====================================================
// ABSTRACTION
// =====================================================

abstract class Counter {
  void increment();
  void reset();
}

// =====================================================
// BASE CLASS
// =====================================================

class TasbheeCounter extends Counter {
  // ===================================================
  // ENCAPSULATION
  // Private variables
  // ===================================================

  String _tasbheeName;
  int _count;

  // Constructor
  TasbheeCounter(this._tasbheeName, [this._count = 0]);

  // Getters
  String get tasbheeName => _tasbheeName;
  int get count => _count;

  // Setter
  set tasbheeName(String name) {
    _tasbheeName = name;
  }

  // ===================================================
  // POLYMORPHISM
  // Method overriding
  // ===================================================

  @override
  void increment() {
    _count++;
  }

  @override
  void reset() {
    _count = 0;
  }
}

// =====================================================
// INHERITANCE
// =====================================================

class DigitalTasbhee extends TasbheeCounter {
  DigitalTasbhee(String name, [int count = 0]) : super(name, count);

  // ===================================================
  // METHOD OVERRIDING
  // ===================================================

  @override
  void increment() {
    super.increment();
  }
}

// =====================================================
// FLUTTER APP
// =====================================================

class TasbheeApp extends StatelessWidget {
  const TasbheeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasbhee Counter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
      ),
      home: const TasbheeHomePage(),
    );
  }
}

// =====================================================
// HOME PAGE
// =====================================================

class TasbheeHomePage extends StatefulWidget {
  const TasbheeHomePage({super.key});

  @override
  State<TasbheeHomePage> createState() => _TasbheeHomePageState();
}

class _TasbheeHomePageState extends State<TasbheeHomePage> {
  // ===================================================
  // OBJECT
  // ===================================================

  final DigitalTasbhee tasbhee =
  DigitalTasbhee('SubhanAllah');

  // Available Tasbih
  final List<String> tasbheeOptions = [
    'SubhanAllah',
    'Alhamdulillah',
    'Allahu Akbar',
    'Astaghfirullah',
    'La ilaha illallah',
  ];

  // ===================================================
  // INCREMENT
  // ===================================================

  void increaseCount() {
    setState(() {
      tasbhee.increment();
    });
  }

  // ===================================================
  // RESET
  // ===================================================

  void resetCount() {
    setState(() {
      tasbhee.reset();
    });
  }

  // ===================================================
  // CHANGE TASBHEE
  // ===================================================

  void changeTasbhee(String? value) {
    if (value == null) return;

    setState(() {
      tasbhee.tasbheeName = value;
      tasbhee.reset();
    });
  }

  // ===================================================
  // UI
  // ===================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),

      // =================================================
      // APP BAR
      // =================================================

      appBar: AppBar(
        title: const Text(
          'Tasbhee Counter',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),

      // =================================================
      // BODY
      // =================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              // ===========================================
              // HEADER
              // ===========================================

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 45,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Digital Tasbhee',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Keep track of your daily Zikr',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ===========================================
              // TASBHEE SELECTION
              // ===========================================

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Tasbhee',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.green.shade100,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: tasbhee.tasbheeName,
                    isExpanded: true,
                    items: tasbheeOptions.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: changeTasbhee,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ===========================================
              // COUNTER CARD
              // ===========================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 35,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [

                    Text(
                      tasbhee.tasbheeName,
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // =====================================
                    // COUNT
                    // =====================================

                    Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.shade50,
                        border: Border.all(
                          color: Colors.green.shade700,
                          width: 5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${tasbhee.count}',
                          style: TextStyle(
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // =====================================
                    // INCREMENT BUTTON
                    // =====================================

                    GestureDetector(
                      onTap: increaseCount,
                      child: Container(
                        height: 75,
                        width: 75,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green.shade700,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Tap to count',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ===========================================
              // RESET BUTTON
              // ===========================================

              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: resetCount,
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'Reset Counter',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green.shade700,
                    side: BorderSide(
                      color: Colors.green.shade700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ===========================================
              // OOP INFO
              // ===========================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Text(
                      'OOP Concepts Used',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Abstraction • Encapsulation • Inheritance • '
                          'Polymorphism • Classes & Objects',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}