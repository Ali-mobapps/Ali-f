import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/inquiry_entity.dart';
import '../../domain/repositories/inquiries_repository.dart';
import '../models/inquiry_model.dart';

class InquiriesRepositoryImpl implements InquiriesRepository {
  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  Future<List<InquiryEntity>> getInquiriesByItem(String itemId) async {
    try {
      final List<dynamic> data = await _supabase
          .from('inquiries')
          .select()
          .eq('item_id', itemId)
          .order('created_at', ascending: true);
          
      return data.map((json) => InquiryModel.fromJson(json, json['id'].toString())).toList();
    } catch (e) {
      print('Error fetching inquiries by item: $e');
      return [];
    }
  }

  @override
  Stream<List<InquiryEntity>> watchInquiriesByItem(String itemId) {
    return _supabase
        .from('inquiries')
        .stream(primaryKey: ['id'])
        .eq('item_id', itemId)
        .order('created_at', ascending: true)
        .map((data) => data
            .map((json) => InquiryModel.fromJson(json, json['id'].toString()))
            .toList());
  }

  @override
  Future<List<InquiryEntity>> getAllInquiries() async {
    try {
      // First, get all inquiries
      final List<dynamic> inquiriesData = await _supabase
          .from('inquiries')
          .select()
          .order('created_at', ascending: false);
          
      if (inquiriesData.isEmpty) return [];

      // Get all unique user IDs to fetch their names
      final userIds = inquiriesData.map((e) => e['user_id']).where((id) => id != null).toSet().toList();
      
      Map<String, String> userNames = {};
      if (userIds.isNotEmpty) {
        final List<dynamic> usersData = await _supabase
            .from('users')
            .select('id, name')
            .inFilter('id', userIds);
        
        for (var user in usersData) {
          userNames[user['id'].toString()] = user['name'] ?? 'Unknown User';
        }
      }

      return inquiriesData.map((json) {
        final inquiry = InquiryModel.fromJson(json, json['id'].toString());
        final userId = json['user_id']?.toString();
        final name = userNames[userId] ?? 'Guest';
        
        return InquiryModel(
          id: inquiry.id,
          userId: inquiry.userId,
          itemId: inquiry.itemId,
          itemType: inquiry.itemType,
          senderRole: inquiry.senderRole,
          message: inquiry.senderRole == 'customer' ? '[$name]: ${inquiry.message}' : inquiry.message,
          createdAt: inquiry.createdAt,
        );
      }).toList();
    } catch (e) {
      print('Error loading all inquiries: $e');
      // Fallback if joined select fails
      final List<dynamic> data = await _supabase
          .from('inquiries')
          .select()
          .order('created_at', ascending: false);
      return data.map((json) => InquiryModel.fromJson(json, json['id'].toString())).toList();
    }
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

  @override
  Future<void> deleteInquiriesByItem(String itemId) async {
    await _supabase.from('inquiries').delete().eq('item_id', itemId);
  }

  @override
  Future<String> uploadInquiryFile(dynamic file, String fileName) async {
    try {
      final String path = 'chat_attachments/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      
      if (file is List<int>) {
        // Handle bytes (Web/Mobile)
        await _supabase.storage.from('chat').uploadBinary(path, file as dynamic);
      } else {
        // Handle File object (Mobile)
        await _supabase.storage.from('chat').upload(path, file);
      }

      return _supabase.storage.from('chat').getPublicUrl(path);
    } catch (e) {
      throw Exception('Failed to upload chat file: $e');
    }
  }
}
