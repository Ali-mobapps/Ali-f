import '../../domain/entities/inquiry_entity.dart';
import '../../domain/repositories/inquiries_repository.dart';

class InquiriesRepositoryImpl implements InquiriesRepository {
  final List<InquiryEntity> _inquiries = [
    InquiryEntity(
      id: '1',
      customerEmail: 'customer@dynetix.com',
      message: 'I want to inquire about the Flutter course enrollment details.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    InquiryEntity(
      id: '2',
      customerEmail: 'customer@dynetix.com',
      message: 'Need details for 3D Modeling and Graphic Design services.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  @override
  Future<List<InquiryEntity>> getInquiries(String email, bool isAdmin) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (isAdmin) {
      return _inquiries;
    }
    return _inquiries.where((e) => e.customerEmail == email).toList();
  }

  @override
  Future<void> sendInquiry(InquiryEntity inquiry) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _inquiries.insert(0, inquiry);
  }
}
