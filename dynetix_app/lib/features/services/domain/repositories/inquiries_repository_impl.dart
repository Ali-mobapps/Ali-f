import 'package:dynetix_app/features/inquiries/domain/entities/inquiry_entity.dart';
import 'package:dynetix_app/features/inquiries/domain/repositories/inquiries_repository.dart';

class InquiriesRepositoryImpl implements InquiriesRepository {
  // Temporary in-memory list for testing
  final List<InquiryEntity> _inquiries = [
    InquiryEntity(
      id: '1',
      customerEmail: 'customer@dynetix.com',
      message:
          'Hello, I want to know more about the Flutter course fee structure.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  @override
  Future<List<InquiryEntity>> getInquiries(String email, bool isAdmin) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (isAdmin) {
      return _inquiries;
    }
    return _inquiries.where((e) => e.customerEmail == email).toList();
  }

  @override
  Future<void> sendInquiry(InquiryEntity inquiry) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _inquiries.insert(0, inquiry);
  }
}
