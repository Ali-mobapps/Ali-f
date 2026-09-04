import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/announcement_repository.dart';
import '../../domain/announcement_entity.dart';
import 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  final AnnouncementRepository repository;

  AnnouncementCubit(this.repository) : super(AnnouncementInitial());

  Future<void> fetchAnnouncements() async {
    emit(AnnouncementLoading());
    try {
      final data = await repository.getAnnouncements();
      emit(AnnouncementLoaded(data));
    } catch (e) {
      emit(AnnouncementError(e.toString()));
    }
  }

  Future<void> broadcast(String title, String content, String type) async {
    try {
      await repository.broadcastAnnouncement(title, content, type);
      fetchAnnouncements();
    } catch (e) {
      emit(AnnouncementError(e.toString()));
    }
  }
}
