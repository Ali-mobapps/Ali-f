import '../entities/inquiry_entity.dart';

abstract class InquiriesRepository {
  Future<List<InquiryEntity>> getInquiriesByItem(String itemId);
  Stream<List<InquiryEntity>> watchInquiriesByItem(String itemId, {String? userId, required String role});
  Future<List<InquiryEntity>> getAllInquiries();
  Future<List<InquiryEntity>> getInquiriesByUser(String userId);
  Future<void> sendInquiry(InquiryEntity inquiry);
  Future<void> deleteInquiriesByItem(String itemId, {String? userId, required String role});
  Future<void> deleteAllInquiries();
  Future<String> uploadInquiryFile(dynamic file, String fileName);
}
