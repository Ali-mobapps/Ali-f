import 'package:flutter/material.dart';
import '../models/student.dart';
import 'menu_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController(text: "Ali Faisal");
  final _idController = TextEditingController(text: "FA20-BCS-001");
  final _balanceController = TextEditingController(text: "1500");
  final _pointsController = TextEditingController(text: "120");
  bool _isHostelite = true;

  void _onContinue() {
    // Create student object with provided values
    final student = Student(
      studentName: _nameController.text,
      studentId: _idController.text,
      walletBalance: double.tryParse(_balanceController.text) ?? 0.0,
      loyaltyPoints: int.tryParse(_pointsController.text) ?? 0,
      isHostelite: _isHostelite,
      isActive: true,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenuScreen(student: student),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Profile Setup"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.account_circle, size: 80, color: Colors.teal),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Student Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: "Registration ID", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _balanceController,
              decoration: const InputDecoration(labelText: "Initial Wallet Balance (Rs.)", border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _pointsController,
              decoration: const InputDecoration(labelText: "Loyalty Points", border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            SwitchListTile(
              title: const Text("Hostelite Student?"),
              value: _isHostelite,
              onChanged: (val) => setState(() => _isHostelite = val),
              activeColor: Colors.teal,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _onContinue,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                child: const Text("CONTINUE TO CANTEEN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
