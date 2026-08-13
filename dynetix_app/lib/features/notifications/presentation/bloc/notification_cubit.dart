import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';

abstract class NotificationState {}
class NotificationInitial extends NotificationState {}
class NotificationLoading extends NotificationState {}
class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  NotificationLoaded(this.notifications);
}
class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;

  NotificationCubit(this.repository) : super(NotificationInitial());

  Future<void> fetchNotifications(String email) async {
    emit(NotificationLoading());
    try {
      final notes = await repository.getNotifications(email);
      emit(NotificationLoaded(notes));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> markRead(String id, String email) async {
    await repository.markAsRead(id);
    fetchNotifications(email);
  }
}
