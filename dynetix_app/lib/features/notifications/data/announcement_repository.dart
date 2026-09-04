import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/announcement_entity.dart';

class AnnouncementRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<AnnouncementEntity>> getAnnouncements() async {
    try {
      final List<dynamic> data = await _supabase
          .from('announcements')
          .select()
          .order('created_at', ascending: false);
      
      return data.map((json) => AnnouncementEntity(
        id: json['id'].toString(),
        title: json['title'],
        content: json['content'],
        createdAt: DateTime.parse(json['created_at']),
        type: json['type'],
      )).toList();
    } catch (e) {
      print('Error fetching announcements: $e');
      return [];
    }
  }

  Future<void> broadcastAnnouncement(String title, String content, String type) async {
    await _supabase.from('announcements').insert({
      'title': title,
      'content': content,
      'type': type,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}
