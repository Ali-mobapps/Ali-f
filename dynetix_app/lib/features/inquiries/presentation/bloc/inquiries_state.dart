import '../../domain/entities/inquiry_entity.dart';

abstract class InquiriesState {}

class InquiriesInitial extends InquiriesState {}

class InquiriesLoading extends InquiriesState {}

class InquiriesLoaded extends InquiriesState {
  final List<InquiryEntity> inquiries;

  InquiriesLoaded(this.inquiries);
}

class InquiriesError extends InquiriesState {
  final String message;

  InquiriesError(this.message);
}
