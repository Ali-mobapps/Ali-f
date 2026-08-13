import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final _supabase = Supabase.instance.client;
  final _msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialNote.isNotEmpty) {
      _sendMessage(widget.initialNote);
    }
  }

  Future<void> _sendMessage(String text) async {
    final userEmail =
        _supabase.auth.currentUser?.email ?? 'anonymous@dynetix.com';
    await _supabase.from('inquiries').insert({
      'user_email': userEmail,
      'service_title': widget.serviceTitle,
      'message': text,
      'is_customer': true,
    });
    _msgController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = _supabase.auth.currentUser?.email ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161925),
        title: Text(widget.serviceTitle, style: const TextStyle(fontSize: 16)),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _supabase
                  .from('inquiries')
                  .stream(primaryKey: ['id'])
                  .eq('service_title', widget.serviceTitle)
                  .order('created_at', ascending: true),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF00E676)));
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isCustomer = msg['is_customer'] as bool;
                    return Align(
                      alignment: isCustomer
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isCustomer
                              ? const Color(0xFF00E676)
                              : const Color(0xFF1E2235),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg['message'],
                          style: TextStyle(
                              color: isCustomer ? Colors.black : Colors.white),
                        ),
                      ),
                    );
                  },
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
                    decoration: const InputDecoration(
                      hintText: 'Type message...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF00E676)),
                  onPressed: () {
                    if (_msgController.text.trim().isNotEmpty) {
                      _sendMessage(_msgController.text.trim());
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
