import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dynetix_widgets.dart';
import '../../domain/entities/inquiry_entity.dart';
import '../../data/models/inquiry_model.dart';
import '../bloc/inquiries_cubit.dart';

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

  // Audio Recording
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;

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
          .eq('user_id', widget.userId)
          .order('created_at', ascending: false) // Reverse order for reverse list
          .map((data) => data
              .map((json) => InquiryModel.fromJson(json, json['id'].toString()))
              .where((msg) {
                if (widget.userRole == 'customer') return !msg.hiddenFromCustomer;
                if (widget.userRole == 'admin') return !msg.hiddenFromAdmin;
                return true;
              })
              .toList());
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        const config = RecordConfig(); // Default config
        await _audioRecorder.start(config, path: path);
        
        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      // Log error silently
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        _handleFileUpload(File(path), 'voice_note.m4a', '[AUDIO]');
      }
    } catch (e) {
      // Log error silently
    }
  }

  void _sendMessage({String? message}) {
    final text = message ?? _messageController.text.trim();
    if (text.isEmpty) return;

    final inquiry = InquiryModel(
      id: '',
      userId: widget.userId,
      itemId: widget.itemId, // Use widget.itemId instead of hardcoded
      itemType: widget.itemId == 'global_support' ? 'support' : 'inquiry',
      senderRole: widget.userRole,
      message: text,
      createdAt: DateTime.now(),
    );

    context.read<InquiriesCubit>().sendInquiry(inquiry);
    if (message == null) _messageController.clear();

    // Auto-Reply Logic for Customer Support
    if (widget.userRole == 'customer') {
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        
        final botInquiry = InquiryModel(
          id: '',
          userId: widget.userId,
          itemId: widget.itemId,
          itemType: 'support',
          senderRole: 'admin', // AI acts as Admin
          message: '🤖 [AI Auto-Reply]: Thank you for reaching out! Our team is currently offline or busy, but we have received your message. An agent will get back to you shortly.',
          createdAt: DateTime.now(),
        );
        
        context.read<InquiriesCubit>().sendInquiry(botInquiry);
      });
    }
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
              context.read<InquiriesCubit>().clearChat(
                widget.itemId, 
                userId: widget.userId,
                role: widget.userRole,
              );
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
          fileToUpload = File(platformFile.path);
        } else if (platformFile is PlatformFile) {
          fileToUpload = File(platformFile.path!);
        }
      }

      if (fileToUpload != null) {
        if (mounted) {
          final url = await context.read<InquiriesCubit>().uploadFile(fileToUpload, fileName);
          _sendMessage(message: '$prefix$url');
        }
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
                    reverse: true, // New messages at bottom
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
    } else if (msg.message.startsWith('[AUDIO]')) {
      fileUrl = msg.message.replaceFirst('[AUDIO]', '');
      content = _VoiceNotePlayer(url: fileUrl, isMe: isMe);
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isRecording)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.mic_rounded, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 12),
                    const Expanded(child: Text('Recording Voice Note...', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13))),
                    IconButton(
                      icon: const Icon(Icons.cancel_outlined, color: AppColors.textDisabled),
                      onPressed: () async {
                        await _audioRecorder.stop();
                        setState(() => _isRecording = false);
                      },
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                if (!_isRecording)
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
                      enabled: !_isRecording,
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
                if (_messageController.text.trim().isEmpty && !_isRecording)
                  GestureDetector(
                    onLongPress: _startRecording,
                    onLongPressUp: _stopRecording,
                    child: Container(
                      height: 48, width: 48,
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.mic_rounded, color: Colors.black, size: 20),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: _isRecording ? _stopRecording : () => _sendMessage(),
                    child: Container(
                      height: 48, width: 48,
                      decoration: BoxDecoration(color: _isRecording ? Colors.redAccent : AppColors.primary, shape: BoxShape.circle),
                      child: Icon(_isRecording ? Icons.stop_rounded : Icons.send_rounded, color: Colors.black, size: 20),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VoiceNotePlayer extends StatefulWidget {
  final String url;
  final bool isMe;
  const _VoiceNotePlayer({required this.url, required this.isMe});

  @override
  State<_VoiceNotePlayer> createState() => _VoiceNotePlayerState();
}

class _VoiceNotePlayerState extends State<_VoiceNotePlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onDurationChanged.listen((d) => setState(() => _duration = d));
    _audioPlayer.onPositionChanged.listen((p) => setState(() => _position = p));
    _audioPlayer.onPlayerComplete.listen((_) => setState(() => _isPlaying = false));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: widget.isMe ? Colors.black : AppColors.primary),
            onPressed: () async {
              if (_isPlaying) {
                await _audioPlayer.pause();
              } else {
                await _audioPlayer.play(UrlSource(widget.url));
              }
              setState(() => _isPlaying = !_isPlaying);
            },
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                    activeTrackColor: widget.isMe ? Colors.black54 : AppColors.primary,
                    inactiveTrackColor: Colors.white10,
                    thumbColor: widget.isMe ? Colors.black : AppColors.primary,
                  ),
                  child: Slider(
                    value: _position.inMilliseconds.toDouble(),
                    max: _duration.inMilliseconds.toDouble() > 0 ? _duration.inMilliseconds.toDouble() : 1.0,
                    onChanged: (value) => _audioPlayer.seek(Duration(milliseconds: value.toInt())),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(_position), style: TextStyle(color: widget.isMe ? Colors.black54 : Colors.white54, fontSize: 8)),
                      Text(_formatDuration(_duration), style: TextStyle(color: widget.isMe ? Colors.black54 : Colors.white54, fontSize: 8)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
