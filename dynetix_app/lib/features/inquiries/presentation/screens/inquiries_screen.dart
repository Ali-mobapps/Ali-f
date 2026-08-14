import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dynetix_widgets.dart';
import '../../domain/entities/inquiry_entity.dart';
import '../bloc/inquiries_cubit.dart';
import '../bloc/inquiries_state.dart';
import 'inquiry_chat_screen.dart';

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
  @override
  void initState() {
    super.initState();
    // For admin, we might want to fetch all unique inquiries.
    // For customer, they see their own.
    // Assuming the Cubit has a method to fetch list of inquiry threads.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.isAdmin ? 'Inquiries' : 'Support Chat', style: const TextStyle(letterSpacing: 1, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: BlocBuilder<InquiriesCubit, InquiriesState>(
        builder: (context, state) {
          if (state is InquiriesLoading) return const Center(child: CircularProgressIndicator());
          
          if (state is InquiriesLoaded) {
            // Group by item_id or unique conversations
            // For now, just showing list
            if (state.inquiries.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.inquiries.length,
              itemBuilder: (context, index) {
                final inquiry = state.inquiries[index];
                return _buildInquiryTile(inquiry);
              },
            );
          }
          
          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline_rounded, size: 64, color: AppColors.textDisabled.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text('No messages yet', style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildInquiryTile(InquiryEntity inquiry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassPanel(
        padding: 4,
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => InquiryChatScreen(
                  itemId: inquiry.itemId,
                  itemTitle: 'Service Inquiry', // Should fetch title
                  userRole: widget.userRole,
                  userId: widget.userId,
                ),
              ),
            );
          },
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.forum_rounded, color: AppColors.primary, size: 20),
          ),
          title: Text(inquiry.message, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          subtitle: Text(inquiry.senderRole.toUpperCase(), style: const TextStyle(color: AppColors.textDisabled, fontSize: 11)),
          trailing: const Icon(Icons.chevron_right, size: 18, color: AppColors.textDisabled),
        ),
      ),
    );
  }
}
