import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/vip_theme.dart';
import '../../domain/entities/inquiry_entity.dart';
import '../bloc/inquiries_cubit.dart';
import '../bloc/inquiries_state.dart';

class InquiriesScreen extends StatefulWidget {
  final bool isAdmin;
  final String userId;
  final String userRole;

  const InquiriesScreen({
    super.key,
    required this.isAdmin,
    required this.userId,
    required this.userRole,
  });

  @override
  State<InquiriesScreen> createState() => _InquiriesScreenState();
}

class _InquiriesScreenState extends State<InquiriesScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // For general inquiries, we use a fixed ID like 'general_support'
    context.read<InquiriesCubit>().watchInquiries('general_support');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VIPTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: VIPTheme.darkBackground,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.isAdmin ? 'Client Support' : 'Ask Admin', 
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: VIPTheme.primaryGold)),
            const Text('We are here to help you 24/7', 
              style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
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
                  final inquiries = state.inquiries;
                  if (inquiries.isEmpty) {
                    return const Center(
                      child: Text(
                        'Start a conversation with Dynetix Admin!',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: inquiries.length,
                    itemBuilder: (context, index) {
                      final inquiry = inquiries[index];
                      final isMe = inquiry.senderRole == widget.userRole;
                      return _buildMessageBubble(inquiry, isMe);
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(InquiryEntity inquiry, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? VIPTheme.primaryGold : VIPTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          inquiry.message,
          style: TextStyle(color: isMe ? Colors.black : Colors.white),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: VIPTheme.cardBackground,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: VIPTheme.darkBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () {
              final text = _controller.text.trim();
              if (text.isNotEmpty) {
                final inquiry = InquiryEntity(
                  id: '',
                  userId: widget.userId,
                  itemId: 'general_support',
                  itemType: 'support',
                  senderRole: widget.userRole,
                  message: text,
                  createdAt: DateTime.now(),
                );
                context.read<InquiriesCubit>().sendInquiry(inquiry);
                _controller.clear();
              }
            },
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
    );
  }
}
