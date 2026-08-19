import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dynetix_widgets.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'isBot': true,
      'message': 'Hello! I am your Dynetix AI Assistant. How can I help you today?',
      'time': DateTime.now()
    }
  ];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'isBot': false,
        'message': text,
        'time': DateTime.now(),
      });
      _isTyping = true;
    });
    
    _controller.clear();
    _scrollToBottom();

    // Fix: Ensure Bot Reply always triggers
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        final response = _getBotResponse(text);
        setState(() {
          _isTyping = false;
          _messages.add({
            'isBot': true,
            'message': response,
            'time': DateTime.now(),
          });
        });
        _scrollToBottom();
      }
    });
  }

  String _getBotResponse(String input) {
    input = input.toLowerCase();
    
    if (input.contains('hello') || input.contains('hi') || input.contains('hey') || input.contains('ky h') || input.contains('kya hal')) {
      return "Greetings from Dynetix! I am your AI Assistant. How can I help you with our elite services today?";
    }
    if (input.contains('pay') || input.contains('payment') || input.contains('paise') || input.contains('money') || input.contains('paisa')) {
      return "For payments, we accept EasyPaisa, JazzCash, and HBL. You can find the details in the 'Payments' tab. Just copy the number and upload the proof in your Project section.";
    }
    if (input.contains('service') || input.contains('work') || input.contains('kaam') || input.contains('offer')) {
      return "Dynetix offers premium 3D Modeling, Web Development, SEO, and Graphic Design. Check the 'Services' tab for the full list and FLAT OFF deals!";
    }
    if (input.contains('course') || input.contains('academy') || input.contains('learn') || input.contains('parhna')) {
      return "Our Academy provides professional courses in AI (Python), Data Analytics, and Business Strategy. Visit the 'Academy' tab to start learning.";
    }
    if (input.contains('status') || input.contains('order') || input.contains('project') || input.contains('progress')) {
      return "You can track your projects in real-time under the 'Projects' tab. It shows if your work is 'In Progress' or 'Completed'.";
    }
    if (input.contains('contact') || input.contains('admin') || input.contains('chat') || input.contains('help')) {
      return "If you need human assistance, please use the 'Chat' tab to message our support team directly.";
    }
    
    return "I am still learning! You can ask me about Services, Courses, Payments, or Project Status. For anything else, please contact our support chat.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI ASSISTANT', style: TextStyle(letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final bool isBot = msg['isBot'] ?? false;
                
                return Align(
                  alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isBot ? AppColors.surface : AppColors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isBot ? 0 : 16),
                        bottomRight: Radius.circular(isBot ? 16 : 0),
                      ),
                    ),
                    child: Text(
                      msg['message'],
                      style: TextStyle(color: isBot ? Colors.white : Colors.black, fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.only(left: 20, bottom: 10),
              child: Align(alignment: Alignment.centerLeft, child: Text('AI is typing...', style: TextStyle(color: AppColors.primary, fontSize: 10))),
            ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.glassBorder))),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(hintText: "Type a message...", border: InputBorder.none),
                onSubmitted: (_) => _handleMessage(),
              ),
            ),
            IconButton(
              onPressed: _handleMessage,
              icon: const Icon(Icons.send_rounded, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
