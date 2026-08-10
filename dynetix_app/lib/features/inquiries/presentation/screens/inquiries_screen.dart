import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/inquiry_entity.dart';
import '../bloc/inquiries_cubit.dart';
import '../bloc/inquiries_state.dart';

class InquiriesScreen extends StatelessWidget {
  final bool isAdmin;
  final String userEmail;

  const InquiriesScreen({
    super.key,
    required this.isAdmin,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    // Pass required arguments here
    context.read<InquiriesCubit>().fetchInquiries(userEmail, isAdmin);

    return Scaffold(
      appBar: AppBar(
        title: Text(isAdmin ? 'Customer Inquiries' : 'Support / Send Inquiry'),
      ),
      body: BlocBuilder<InquiriesCubit, InquiriesState>(
        builder: (context, state) {
          if (state is InquiriesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is InquiriesLoaded) {
            if (state.inquiries.isEmpty) {
              return const Center(child: Text('No inquiries found.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.inquiries.length,
              itemBuilder: (context, index) {
                final inquiry = state.inquiries[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          // Fixed from MainAxisAlignment.between to MainAxisAlignment.spaceBetween
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              inquiry.customerEmail,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            Text(
                              '${inquiry.timestamp.hour}:${inquiry.timestamp.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(inquiry.message),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is InquiriesError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: !isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _showSendInquiryDialog(context),
              label: const Text('New Message'),
              icon: const Icon(Icons.send),
            )
          : null,
    );
  }

  void _showSendInquiryDialog(BuildContext context) {
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Send Inquiry to Admin'),
          content: TextField(
            controller: messageController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Type your message or question here...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final messageText = messageController.text.trim();
                if (messageText.isNotEmpty) {
                  final newInquiry = InquiryEntity(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    customerEmail: userEmail,
                    message: messageText,
                    timestamp: DateTime.now(),
                  );

                  // Pass all 3 required arguments to sendInquiry
                  context.read<InquiriesCubit>().sendInquiry(
                        newInquiry,
                        userEmail,
                        isAdmin,
                      );
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }
}
