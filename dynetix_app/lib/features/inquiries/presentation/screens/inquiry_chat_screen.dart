import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dynetix_widgets.dart';
import '../../domain/entities/inquiry_entity.dart';
import '../../data/models/inquiry_model.dart';
import '../bloc/inquiries_cubit.dart';
import '../bloc/inquiries_state.dart';

class InquiryChatScreen extends StatefulWidget {
  final String itemId;
  final String itemTitle;
  final String userRole;
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
  Stream<List<InquiryEntity>>? _inquiryStream;

  @override
  void initState() {
    super.initState();
    _initStream();
  }

  void _initStream() {
    setState(() {
      _inquiryStream = Supabase.instance.client
          .from('inquiries')
          .stream(primaryKey: ['id'])
          .eq('item_id', widget.itemId)
          .order('created_at', ascending: true)
          .map((data) => data
              .map((json) => InquiryModel.fromJson(json, json['id'].toString()))
              .toList());
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage({String? message}) {
    final text = message ?? _messageController.text.trim();
    if (text.isEmpty) return;

    final inquiry = InquiryModel(
      id: '', 
      userId: widget.userId,
      itemId: widget.itemId,
      itemType: 'service',
      senderRole: widget.userRole,
      message: text,
      createdAt: DateTime.now(),
    );

    context.read<InquiriesCubit>().sendInquiry(inquiry);
    if (message == null) _messageController.clear();
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Clear Chat', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to clear this conversation?', style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              context.read<InquiriesCubit>().clearChat(widget.itemId);
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAttachment() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAttachmentType(Icons.image_rounded, 'Gallery', () async {
              Navigator.pop(context);
              final picker = ImagePicker();
              final image =
                  await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                _handleFileUpload(image, image.name, '[IMAGE]');
              }
            }),
            _buildAttachmentType(Icons.picture_as_pdf_rounded, 'PDF', () async {
              Navigator.pop(context);
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom, allowedExtensions: ['pdf']);
              if (result != null) {
                final file = result.files.single;
                _handleFileUpload(file, file.name, '[PDF]');
              }
            }),
            _buildAttachmentType(Icons.folder_zip_rounded, 'ZIP', () async {
              Navigator.pop(context);
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom, allowedExtensions: ['zip', 'rar']);
              if (result != null) {
                final file = result.files.single;
                _handleFileUpload(file, file.name, '[ZIP]');
              }
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _handleFileUpload(dynamic platformFile, String fileName, String prefix) async {
    // Show loading
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Uploading $fileName...'), duration: const Duration(seconds: 2)),
    );

    try {
      dynamic fileToUpload;
      if (kIsWeb) {
        if (platformFile is XFile) {
          fileToUpload = await platformFile.readAsBytes();
        } else if (platformFile is PlatformFile) {
          fileToUpload = platformFile.bytes;
        }
      } else {
        if (platformFile is XFile) {
          fileToUpload = File(platformFile.path!);
        } else if (platformFile is PlatformFile) {
          fileToUpload = File(platformFile.path!);
        }
      }

      if (fileToUpload != null) {
        final url = await context.read<InquiriesCubit>().uploadFile(fileToUpload, fileName);
        _sendMessage(message: '$prefix$url');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  Widget _buildAttachmentType(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 30, backgroundColor: AppColors.primary.withValues(alpha: 0.1), child: Icon(icon, color: AppColors.primary)),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.itemTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Text('Dynetix Support • Online', style: TextStyle(fontSize: 10, color: AppColors.success)),
          ],
        ),
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent, size: 20),
            onPressed: _clearChat,
            tooltip: 'Clear Chat',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<InquiryEntity>>(
              stream: _inquiryStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }
                
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.redAccent),
                        const SizedBox(height: 16),
                        const Text('Realtime connection timed out.', style: TextStyle(color: Colors.white)),
                        const Text('Please check if Realtime is enabled in Supabase.', style: TextStyle(color: AppColors.textDisabled, fontSize: 12)),
                        const SizedBox(height: 16),
                        DynetixButton(
                          text: 'RETRY CONNECTION',
                          onPressed: _initStream,
                          isOutline: true,
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasData) {
                  final messages = snapshot.data!;
                  if (messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.forum_outlined, size: 64, color: AppColors.textDisabled.withValues(alpha: 0.2)),
                          const SizedBox(height: 16),
                          const Text('No messages yet. Start chatting!', style: TextStyle(color: AppColors.textDisabled)),
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
                      
                      return _buildMessageBubble(msg, isMe);
                    },
                  );
                }
                
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent)));
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

  Widget _buildMessageBubble(InquiryEntity msg, bool isMe) {
    Widget content;
    bool isFile = false;
    String? fileUrl;

    if (msg.message.startsWith('[IMAGE]')) {
      fileUrl = msg.message.replaceFirst('[IMAGE]', '');
      isFile = true;
      content = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          fileUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          },
          errorBuilder: (context, error, stackTrace) => const Padding(
            padding: EdgeInsets.all(20),
            child: Icon(Icons.broken_image_rounded, color: Colors.white54),
          ),
        ),
      );
    } else if (msg.message.startsWith('[PDF]')) {
      fileUrl = msg.message.replaceFirst('[PDF]', '');
      final name = fileUrl.split('/').last.split('?').first;
      content = _buildFileItem(Icons.picture_as_pdf_rounded, name, Colors.redAccent);
    } else if (msg.message.startsWith('[ZIP]')) {
      fileUrl = msg.message.replaceFirst('[ZIP]', '');
      final name = fileUrl.split('/').last.split('?').first;
      content = _buildFileItem(Icons.folder_zip_rounded, name, Colors.orangeAccent);
    } else if (msg.message.startsWith('http')) {
      fileUrl = msg.message;
      content = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(fileUrl, fit: BoxFit.cover),
      );
      isFile = true;
    } else {
      content = Text(
        msg.message,
        style: TextStyle(color: isMe ? Colors.black : Colors.white, fontSize: 14),
      );
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: () async {
          if (fileUrl != null) {
            final Uri url = Uri.parse(fileUrl);
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: isFile ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          decoration: BoxDecoration(
            color: isMe ? AppColors.primary : AppColors.cardBackground,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMe ? 16 : 0),
              bottomRight: Radius.circular(isMe ? 0 : 16),
            ),
          ),
          child: content,
        ),
      ),
    );
  }

  Widget _buildFileItem(IconData icon, String name, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.open_in_new_rounded, color: Colors.white30, size: 16),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
              onPressed: _pickAttachment,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(30)),
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  onSubmitted: (_) => _sendMessage(),
                  decoration: const InputDecoration(
                    hintText: "Message Support...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColors.textDisabled),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => _sendMessage(),
              child: Container(
                height: 48, width: 48,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: const Icon(Icons.send_rounded, color: Colors.black, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
