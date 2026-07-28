
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import '../widgets/calculator_button.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '';
  String _result = '0';
  final List<String> _history = [];

  void _onButtonPressed(String text) {
    setState(() {
      if (text == 'C') {
        _input = '';
        _result = '0';
      } else if (text == '⌫') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else if (text == '=') {
        _calculateResult();
      } else {
        _input += text;
      }
    });
  }

  void _calculateResult() {
    try {
      String finalInput = _input.replaceAll('×', '*');
      Parser p = Parser();
      Expression exp = p.parse(finalInput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      String formattedResult;
      if (eval == eval.toInt()) {
        formattedResult = eval.toInt().toString();
      } else {
        formattedResult = eval.toStringAsFixed(2);
      }

      _history.insert(0, "$_input = $formattedResult");
      _result = formattedResult;
    } catch (e) {
      _result = 'Error';
    }
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top Display & History Area (Flex 2 taaki buttons ko space miley)
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "History",
                          style: TextStyle(color: Colors.orangeAccent, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        if (_history.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 18),
                            onPressed: _clearHistory,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: _history.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1.0),
                            child: Text(
                              _history[index],
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(color: Colors.white24, height: 10),
                    Text(
                      _input,
                      style: const TextStyle(fontSize: 26, color: Colors.white70),
                    ),
                    Text(
                      _result,
                      style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            // Buttons Area (Flex 5 taaki 5 rows perfectly fit hon)
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CalculatorButton(text: "C", onPressed: () => _onButtonPressed("C")),
                        CalculatorButton(text: "⌫", onPressed: () => _onButtonPressed("⌫")),
                        CalculatorButton(text: "%", onPressed: () => _onButtonPressed("%")),
                        CalculatorButton(text: "/", onPressed: () => _onButtonPressed("/")),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        CalculatorButton(text: "7", onPressed: () => _onButtonPressed("7")),
                        CalculatorButton(text: "8", onPressed: () => _onButtonPressed("8")),
                        CalculatorButton(text: "9", onPressed: () => _onButtonPressed("9")),
                        CalculatorButton(text: "×", onPressed: () => _onButtonPressed("×")),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        CalculatorButton(text: "4", onPressed: () => _onButtonPressed("4")),
                        CalculatorButton(text: "5", onPressed: () => _onButtonPressed("5")),
                        CalculatorButton(text: "6", onPressed: () => _onButtonPressed("6")),
                        CalculatorButton(text: "-", onPressed: () => _onButtonPressed("-")),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        CalculatorButton(text: "1", onPressed: () => _onButtonPressed("1")),
                        CalculatorButton(text: "2", onPressed: () => _onButtonPressed("2")),
                        CalculatorButton(text: "3", onPressed: () => _onButtonPressed("3")),
                        CalculatorButton(text: "+", onPressed: () => _onButtonPressed("+")),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        CalculatorButton(text: "00", onPressed: () => _onButtonPressed("00")),
                        CalculatorButton(text: "0", onPressed: () => _onButtonPressed("0")),
                        CalculatorButton(text: ".", onPressed: () => _onButtonPressed(".")),
                        CalculatorButton(text: "=", onPressed: () => _onButtonPressed("=")),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}