import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const BMICalculatorApp());

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFE1F5FE), // Sky Blue Background
      ),
      home: const BMIScreen(),
    );
  }
}

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});
  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  String _gender = 'Male';
  double? _bmi;
  String _cat = '', _suggest = '', _tip = '';
  Color _color = Colors.green;
  late AnimationController _anim;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _scale = CurvedAnimation(parent: _anim, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _heightCtrl.dispose(); _weightCtrl.dispose(); _anim.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      double h = double.parse(_heightCtrl.text) / 100;
      double w = double.parse(_weightCtrl.text);
      setState(() {
        _bmi = w / pow(h, 2);
        _suggest = "Ideal: ${(18.5 * pow(h, 2)).toStringAsFixed(1)} - ${(24.9 * pow(h, 2)).toStringAsFixed(1)} kg";
        if (_bmi! < 18.5) {
          _cat = "Underweight"; _color = Colors.orange[800]!;
          _tip = "Eat nutrient-dense foods & strength train.";
        } else if (_bmi! < 25) {
          _cat = "Normal"; _color = Colors.green[800]!;
          _tip = "Great shape! Maintain your lifestyle.";
        } else if (_bmi! < 30) {
          _cat = "Overweight"; _color = Colors.deepOrangeAccent;
          _tip = "Control portions & exercise regularly.";
        } else {
          _cat = "Obese"; _color = Colors.red[800]!;
          _tip = "Consult a health professional.";
        }
      });
      _anim.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent, // Pink AppBar
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(child: _genderBtn('Male', Icons.male)),
                      const SizedBox(width: 15),
                      Expanded(child: _genderBtn('Female', Icons.female)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.white, // White Box Background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.purple, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Expanded(child: _input(_heightCtrl, 'Height (cm)', Icons.height)),
                          const SizedBox(width: 10),
                          Expanded(child: _input(_weightCtrl, 'Weight (kg)', Icons.monitor_weight)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _calculate,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, padding: const EdgeInsets.symmetric(vertical: 12)),
                          child: const Text('Calculate', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _heightCtrl.clear(); _weightCtrl.clear();
                            setState(() { _bmi = null; }); _anim.reverse();
                          },
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.purple)),
                          child: const Text('Reset', style: TextStyle(color: Colors.purple)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_bmi != null)
                    ScaleTransition(
                      scale: _scale,
                      child: Card(
                        color: const Color(0xFFE8F5E9), // Light Green Result Box
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(color: Colors.green, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Text(_bmi!.toStringAsFixed(1), style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: _color)),
                              Text(_cat, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _color)),
                              const Divider(color: Colors.green),
                              Text(_suggest, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Text(_tip, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _genderBtn(String g, IconData icon) {
    bool sel = _gender == g;
    return InkWell(
      onTap: () => setState(() => _gender = g),
      child: Card(
        color: sel ? Colors.purple : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.purple)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Icon(icon, color: sel ? Colors.white : Colors.purple, size: 24),
              Text(g, style: TextStyle(color: sel ? Colors.white : Colors.purple, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController ctrl, String label, IconData icon) {
    return TextFormField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.purple, size: 20),
        filled: true,
        fillColor: const Color(0xFFF3E5F5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
    );
  }
}