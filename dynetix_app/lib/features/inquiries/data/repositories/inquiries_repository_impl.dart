import 'dart:io';
import 'dart:typed_data';

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
  Stream<List<InquiryEntity>> watchInquiriesByItem(String itemId, {String? userId, required String role}) {
    var query = _supabase
        .from('inquiries')
        .stream(primaryKey: ['id'])
        .eq('item_id', itemId);
    
    if (userId != null) {
      query = query.eq('user_id', userId);
    }

    return query.order('created_at', ascending: true).map((data) {
      return data
          .map((json) => InquiryModel.fromJson(json, json['id'].toString()))
          .where((msg) {
            if (role == 'customer') return !msg.hiddenFromCustomer;
            if (role == 'admin') return !msg.hiddenFromAdmin;
            return true;
          })
          .toList();
    });
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
  Future<List<InquiryEntity>> getInquiriesByUser(String userId) async {
    try {
      final List<dynamic> data = await _supabase
          .from('inquiries')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return data.map((json) => InquiryModel.fromJson(json, json['id'].toString())).toList();
    } catch (e) {
      return [];
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
  Future<void> deleteAllInquiries() async {
    // This will clear the entire inquiries table for Admin
    await _supabase.from('inquiries').delete().neq('id', '0'); 
  }

  @override
  Future<void> deleteInquiriesByItem(String itemId, {String? userId, required String role}) async {
    if (role == 'admin') {
      // Admin deletes permanently all messages for this user (WhatsApp Thread style)
      if (userId != null) {
        await _supabase.from('inquiries').delete().eq('user_id', userId);
      } else {
        await _supabase.from('inquiries').delete().eq('item_id', itemId);
      }
    } else {
      // Customer hide logic
      if (userId != null) {
        await _supabase.from('inquiries').update({'hidden_from_customer': true}).eq('user_id', userId);
      }
    }
  }

  @override
  Future<String> uploadInquiryFile(dynamic file, String fileName) async {
    try {
      final String path = 'chat_attachments/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      
      if (file is List<int>) {
        await _supabase.storage.from('chat').uploadBinary(path, Uint8List.fromList(file));
      } else if (file is File) {
        await _supabase.storage.from('chat').upload(path, file);
      } else {
        // Fallback for other types
        await _supabase.storage.from('chat').upload(path, file);
      }

      return _supabase.storage.from('chat').getPublicUrl(path);
    } catch (e) {
      throw Exception('Failed to upload chat file: $e');
    }
  }
}
