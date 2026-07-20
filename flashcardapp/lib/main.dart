import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FlashcardScreen(),
  ));
}

class Flashcard {
  final String question;
  final String answer;

  const Flashcard({
    required this.question,
    required this.answer,
  });
}

class FlashcardScreen extends StatelessWidget {
  const FlashcardScreen({super.key});

  static const List<Flashcard> flashcards = [
    Flashcard(
      question: "What is the Capital of France?",
      answer: "Paris",
    ),
    Flashcard(
      question: "What is 2 + 2?",
      answer: "4",
    ),
    Flashcard(
      question: "What is the Largest Planet?",
      answer: "Jupiter",
    ),
    Flashcard(
      question: "What is your age?",
      answer: "16",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flashcard App"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: flashcards.length,
        itemBuilder: (context, index) {
          return FlashcardWidget(
            flashcard: flashcards[index],
          );
        },
      ),
    );
  }
}

class FlashcardWidget extends StatefulWidget {
  final Flashcard flashcard;

  const FlashcardWidget({
    super.key,
    required this.flashcard,
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget> {
  bool showAnswer = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showAnswer = !showAnswer;
        });
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              showAnswer
                  ? widget.flashcard.answer
                  : widget.flashcard.question,
              key: ValueKey(showAnswer),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
      ),
    );
  }
}