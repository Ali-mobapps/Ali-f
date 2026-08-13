import 'package:flutter/material.dart';

class CustomerChatScreen extends StatefulWidget {
  final String serviceTitle;
  final String initialNote;

  const CustomerChatScreen(
      {Key? key, required this.serviceTitle, required this.initialNote})
      : super(key: key);

  @override
  State<CustomerChatScreen> createState() => _CustomerChatScreenState();
}

class _CustomerChatScreenState extends State<CustomerChatScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final _msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialNote.isNotEmpty) {
      _messages
          .add({'text': widget.initialNote, 'isCustomer': true, 'time': 'Now'});
      // Simulated Auto Reply from Admin
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _messages.add({
              'text':
                  'Hello! Thanks for asking about "${widget.serviceTitle}". How can our team help you further?',
              'isCustomer': false,
              'time': 'Now'
            });
          });
        }
      });
    }
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'text': text, 'isCustomer': true, 'time': 'Now'});
      _msgController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161925),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.serviceTitle,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Text('Dynetix Admin Support (Online)',
                style: TextStyle(fontSize: 11, color: Color(0xFF00E676))),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isCustomer = msg['isCustomer'] as bool;
                return Align(
                  alignment:
                      isCustomer ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isCustomer
                          ? const Color(0xFF00E676)
                          : const Color(0xFF1E2235),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: Radius.circular(isCustomer ? 12 : 0),
                        bottomRight: Radius.circular(isCustomer ? 0 : 12),
                      ),
                    ),
                    child: Text(
                      msg['text'],
                      style: TextStyle(
                          color: isCustomer ? Colors.black : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            color: const Color(0xFF161925),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF1E2235),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF00E676)),
                  icon: const Icon(Icons.send_rounded, color: Colors.black),
                  onPressed: _sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
