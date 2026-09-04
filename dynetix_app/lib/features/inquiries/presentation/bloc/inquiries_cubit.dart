import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/inquiry_entity.dart';
import '../../domain/repositories/inquiries_repository.dart';
import 'inquiries_state.dart';

class InquiriesCubit extends Cubit<InquiriesState> {
  final InquiriesRepository repository;
  StreamSubscription? _subscription;

  InquiriesCubit(this.repository) : super(InquiriesInitial());

  void watchInquiries(String itemId, {String? userId, required String role}) {
    emit(InquiriesLoading());
    _subscription?.cancel();
    _subscription = repository.watchInquiriesByItem(itemId, userId: userId, role: role).listen(
      (inquiries) => emit(InquiriesLoaded(inquiries)),
      onError: (e) => emit(InquiriesError(e.toString())),
    );
  }

  Future<void> sendInquiry(InquiryEntity inquiry) async {
    try {
      await repository.sendInquiry(inquiry);
    } catch (e) {
      emit(InquiriesError(e.toString()));
    }
  }

  Future<void> clearChat(String itemId, {String? userId, required String role}) async {
    try {
      await repository.deleteInquiriesByItem(itemId, userId: userId, role: role);
    } catch (e) {
      emit(InquiriesError(e.toString()));
    }
  }

  Future<void> deleteAllInquiries() async {
    try {
      await repository.deleteAllInquiries();
      // No need to emit success, just refresh manually or let stream handle it
    } catch (e) {
      emit(InquiriesError(e.toString()));
    }
  }

  Future<String> uploadFile(dynamic file, String fileName) async {
    try {
      return await repository.uploadInquiryFile(file, fileName);
    } catch (e) {
      emit(InquiriesError(e.toString()));
      rethrow;
    }
  }

  Future<void> fetchInquiries(String identifier, bool isAdmin) async {
    emit(InquiriesLoading());
    try {
      if (isAdmin) {
        final inquiries = await repository.getAllInquiries();
        emit(InquiriesLoaded(inquiries));
      } else {
        final inquiries = await repository.getInquiriesByUser(identifier);
        emit(InquiriesLoaded(inquiries));
      }
    } catch (e) {
      emit(InquiriesError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
