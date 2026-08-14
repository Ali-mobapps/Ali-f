import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/inquiry_entity.dart';
import '../../domain/repositories/inquiries_repository.dart';
import 'inquiries_state.dart';

class InquiriesCubit extends Cubit<InquiriesState> {
  final InquiriesRepository repository;
  StreamSubscription? _subscription;

  InquiriesCubit(this.repository) : super(InquiriesInitial());

  void watchInquiries(String itemId) {
    emit(InquiriesLoading());
    _subscription?.cancel();
    _subscription = repository.watchInquiriesByItem(itemId).listen(
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

  Future<void> fetchInquiries(String identifier, bool isAdmin) async {
    emit(InquiriesLoading());
    try {
      if (isAdmin) {
        final inquiries = await repository.getAllInquiries();
        emit(InquiriesLoaded(inquiries));
      } else {
        // Customer logic if needed, usually they see by item
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
