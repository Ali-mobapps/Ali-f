import 'dart:io';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/orders_repository.dart';
import '../models/order_model.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  Stream<List<OrderEntity>> watchCustomerOrders(String userId) {
    return _supabase
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('customer_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => OrderModel.fromJson(json)).toList());
  }

  @override
  Stream<List<OrderEntity>> watchAllOrders() {
    return _supabase
        .from('orders')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => OrderModel.fromJson(json)).toList());
  }

  @override
  Future<void> createOrder(OrderEntity order) async {
    final model = OrderModel(
      id: order.id,
      customerId: order.customerId,
      serviceId: order.serviceId,
      status: order.status,
      price: order.price,
      serviceTitle: order.serviceTitle,
      createdAt: order.createdAt,
      paymentStatus: order.paymentStatus,
      paymentScreenshot: order.paymentScreenshot,
    );
    await _supabase.from('orders').insert(model.toJson());
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _supabase.from('orders').update({'status': status}).eq('id', orderId);
  }

  @override
  Future<void> updatePaymentStatus(String orderId, String status, {String? screenshotUrl}) async {
    final Map<String, dynamic> data = {'payment_status': status};
    if (screenshotUrl != null) {
      data['payment_screenshot'] = screenshotUrl;
    }
    await _supabase.from('orders').update(data).eq('id', orderId);
  }

  @override
  Future<String> uploadPaymentScreenshot(dynamic file, String orderId) async {
    try {
      final String path = '$orderId/proof_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      if (file is File) {
        await _supabase.storage.from('payments').upload(path, file);
      } else {
        await _supabase.storage.from('payments').uploadBinary(path, Uint8List.fromList(file as List<int>));
      }

      return _supabase.storage.from('payments').getPublicUrl(path);
    } catch (e) {
      throw Exception('Failed to upload payment proof: $e');
    }
  }

  @override
  Future<String> uploadDeliverable(dynamic file, String orderId, String fileName) async {
    try {
      final String path = '$orderId/files/$fileName';
      
      if (file is File) {
        await _supabase.storage.from('deliverables').upload(path, file);
      } else {
        await _supabase.storage.from('deliverables').uploadBinary(path, Uint8List.fromList(file as List<int>));
      }

      return _supabase.storage.from('deliverables').getPublicUrl(path);
    } catch (e) {
      throw Exception('Failed to upload deliverable: $e');
    }
  }

  @override
  Future<void> updateDeliverables(String orderId, List<String> urls) async {
    await _supabase.from('orders').update({'deliverables': urls}).eq('id', orderId);
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    await _supabase.from('orders').delete().eq('id', orderId);
  }
}
