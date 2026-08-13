import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/vip_theme.dart';
import '../../domain/entities/inquiry_entity.dart';
import '../bloc/inquiries_cubit.dart';
import '../bloc/inquiries_state.dart';

class InquiryChatScreen extends StatefulWidget {
  final String itemId;
  final String itemTitle;
  final String userRole; // 'admin' or 'customer'
  final String userId;

  const InquiryChatScreen({
    super.key,
    required this.itemId,
    required this.itemTitle,
    required this.userRole,
    required this.userId,
  });

  @override
  State<InquiryChatScreen> createState() => _InquiryChatScreenState();
}

class _InquiryChatScreenState extends State<InquiryChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<InquiriesCubit>().watchInquiries(widget.itemId);
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final inquiry = InquiryEntity(
      id: '', 
      userId: widget.userId,
      itemId: widget.itemId,
      itemType: 'service',
      senderRole: widget.userRole,
      message: _messageController.text.trim(),
      createdAt: DateTime.now(),
    );

    context.read<InquiriesCubit>().sendInquiry(inquiry);
    _messageController.clear();
    
    // Auto scroll to bottom
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VIPTheme.darkBackground,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.itemTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Text('Support Agent • Online', style: TextStyle(fontSize: 10, color: VIPTheme.primaryGold)),
          ],
        ),
        backgroundColor: VIPTheme.cardBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: VIPTheme.primaryGold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<InquiriesCubit, InquiriesState>(
              builder: (context, state) {
                if (state is InquiriesLoading) {
                  return const Center(child: CircularProgressIndicator(color: VIPTheme.primaryGold));
                } else if (state is InquiriesLoaded) {
                  final messages = state.inquiries;
                  if (messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded, size: 60, color: VIPTheme.primaryGold.withValues(alpha: 0.3)),
                          const SizedBox(height: 16),
                          const Text('Ask us anything about this service!', style: TextStyle(color: Colors.white54)),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg.senderRole == widget.userRole;

                      return _buildChatBubble(msg, isMe);
                    },
                  );
                } else if (state is InquiriesError) {
                  return Center(child: Text(state.message, style: const TextStyle(color: Colors.redAccent)));
                }
                return const SizedBox();
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(InquiryEntity msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isMe ? VIPTheme.primaryGold : VIPTheme.cardBackground,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isMe ? 20 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              msg.message,
              style: TextStyle(
                color: isMe ? Colors.black : Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              DateFormat('hh:mm a').format(msg.createdAt),
              style: const TextStyle(color: Colors.white38, fontSize: 9),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VIPTheme.cardBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: VIPTheme.darkBackground,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: "Type your message...",
                    hintStyle: TextStyle(color: Colors.white38),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: VIPTheme.primaryGold,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send_rounded, color: Colors.black, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
