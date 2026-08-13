import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final _supabase = Supabase.instance.client;

  @override
  Future<List<NotificationEntity>> getNotifications(String userEmail) async {
    final List<dynamic> response = await _supabase
        .from('notifications')
        .select()
        .eq('user_email', userEmail)
        .order('timestamp', ascending: false);
    
    return response.map<NotificationEntity>((json) => NotificationEntity(
      id: json['id'].toString(),
      title: json['title'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['is_read'] ?? false,
    )).toList();
  }

  @override
  Future<void> markAsRead(String id) async {
    await _supabase.from('notifications').update({'is_read': true}).eq('id', id);
  }

  @override
  Future<void> clearAll(String userEmail) async {
    await _supabase.from('notifications').delete().eq('user_email', userEmail);
  }
}
