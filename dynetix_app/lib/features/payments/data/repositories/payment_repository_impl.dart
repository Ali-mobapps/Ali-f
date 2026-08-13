import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../models/payment_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  Future<List<PaymentEntity>> getPayments() async {
    try {
      final List<dynamic> data = await _supabase
          .from('payments')
          .select()
          .order('timestamp', ascending: false);
      
      return data.map<PaymentEntity>((json) => PaymentModel.fromJson({...json, 'id': json['id'].toString()})).toList();
    } catch (e) {
      throw Exception('Failed to fetch payments: $e');
    }
  }

  @override
  Future<void> processPayment(PaymentEntity payment) async {
    try {
      final model = PaymentModel(
        id: payment.id,
        itemTitle: payment.itemTitle,
        amount: payment.amount,
        status: payment.status,
        timestamp: payment.timestamp,
      );
      await _supabase.from('payments').insert(model.toJson());
    } catch (e) {
      throw Exception('Failed to process payment: $e');
    }
  }
}
