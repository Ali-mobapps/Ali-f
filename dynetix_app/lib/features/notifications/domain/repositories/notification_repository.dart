import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications(String userEmail);
  Future<void> markAsRead(String id);
  Future<void> clearAll(String userEmail);
}
