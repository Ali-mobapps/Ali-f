import '../entities/inquiry_entity.dart';

abstract class InquiriesRepository {
  Future<List<InquiryEntity>> getInquiries(String email, bool isAdmin);

  Future<void> sendInquiry(InquiryEntity inquiry);
}
