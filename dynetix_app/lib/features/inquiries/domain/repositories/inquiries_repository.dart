import '../entities/inquiry_entity.dart';

abstract class InquiriesRepository {
  Future<List<InquiryEntity>> getInquiriesByItem(String itemId);
  Stream<List<InquiryEntity>> watchInquiriesByItem(String itemId);
  Future<List<InquiryEntity>> getAllInquiries();
  Future<void> sendInquiry(InquiryEntity inquiry);
}
