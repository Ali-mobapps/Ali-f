import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/inquiry_entity.dart';
import '../../domain/repositories/inquiries_repository.dart';
import 'inquiries_state.dart';

class InquiriesCubit extends Cubit<InquiriesState> {
  final InquiriesRepository repository;

  InquiriesCubit(this.repository) : super(InquiriesInitial());

  Future<void> fetchInquiries(String email, bool isAdmin) async {
    emit(InquiriesLoading());
    try {
      final inquiries = await repository.getInquiries(email, isAdmin);
      emit(InquiriesLoaded(inquiries));
    } catch (e) {
      emit(InquiriesError(e.toString()));
    }
  }

  Future<void> sendInquiry(
      InquiryEntity inquiry, String email, bool isAdmin) async {
    emit(InquiriesLoading());
    try {
      await repository.sendInquiry(inquiry);
      final inquiries = await repository.getInquiries(email, isAdmin);
      emit(InquiriesLoaded(inquiries));
    } catch (e) {
      emit(InquiriesError(e.toString()));
    }
  }
}
