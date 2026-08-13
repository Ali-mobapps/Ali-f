import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/inquiry_entity.dart';
import '../../domain/repositories/inquiries_repository.dart';
import '../models/inquiry_model.dart';

class InquiriesRepositoryImpl implements InquiriesRepository {
  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  Future<List<InquiryEntity>> getInquiriesByItem(String itemId) async {
    final List<dynamic> data = await _supabase
        .from('inquiries')
        .select()
        .eq('item_id', itemId)
        .order('created_at', ascending: true);
        
    return data.map<InquiryEntity>((json) => InquiryModel.fromJson(json, json['id'].toString())).toList();
  }

  @override
  Stream<List<InquiryEntity>> watchInquiriesByItem(String itemId) {
    return _supabase
        .from('inquiries')
        .stream(primaryKey: ['id'])
        .eq('item_id', itemId)
        .order('created_at', ascending: true)
        .map((data) => data
            .map<InquiryEntity>((json) => InquiryModel.fromJson(json, json['id'].toString()))
            .toList());
  }

  @override
  Future<List<InquiryEntity>> getAllInquiries() async {
    final List<dynamic> data = await _supabase
        .from('inquiries')
        .select()
        .order('created_at', ascending: false);
        
    return data.map<InquiryEntity>((json) => InquiryModel.fromJson(json, json['id'].toString())).toList();
  }

  @override
  Future<void> sendInquiry(InquiryEntity inquiry) async {
    final model = InquiryModel(
      id: inquiry.id,
      userId: inquiry.userId,
      itemId: inquiry.itemId,
      itemType: inquiry.itemType,
      senderRole: inquiry.senderRole,
      message: inquiry.message,
      createdAt: inquiry.createdAt,
    );
    
    await _supabase.from('inquiries').insert(model.toJson());
  }
}
