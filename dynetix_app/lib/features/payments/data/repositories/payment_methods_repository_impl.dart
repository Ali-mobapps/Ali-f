import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/repositories/payment_methods_repository.dart';
import '../models/payment_method_model.dart';

class PaymentMethodsRepositoryImpl implements PaymentMethodsRepository {
  SupabaseClient get _supabase => Supabase.instance.client;

  @override
  Future<List<PaymentMethodEntity>> getPaymentMethods() async {
    try {
      final List<dynamic> data = await _supabase.from('payment_methods').select();
      return data.map((json) => PaymentMethodModel.fromJson(json, json['id'].toString())).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updatePaymentMethod(PaymentMethodEntity method) async {
    final model = PaymentMethodModel(
      id: method.id,
      name: method.name,
      accountNumber: method.accountNumber,
      accountTitle: method.accountTitle,
      logoUrl: method.logoUrl,
      isActive: method.isActive,
    );
    await _supabase.from('payment_methods').update(model.toJson()).eq('id', method.id);
  }

  @override
  Future<void> addPaymentMethod(PaymentMethodEntity method) async {
    final model = PaymentMethodModel(
      id: method.id,
      name: method.name,
      accountNumber: method.accountNumber,
      accountTitle: method.accountTitle,
      logoUrl: method.logoUrl,
      isActive: method.isActive,
    );
    await _supabase.from('payment_methods').insert(model.toJson());
  }

  @override
  Future<void> seedInitialMethods() async {
    final methods = [
      {'name': 'EasyPaisa', 'number': '03451495330', 'title': 'Dynetix Official'},
      {'name': 'JazzCash', 'number': '03087249533', 'title': 'Dynetix Official'},
      {'name': 'HBL', 'number': '16277900607203', 'title': 'Dynetix Tech'},
      {'name': 'NayaPay', 'number': '03156717093', 'title': 'Dynetix Official'},
      {'name': 'SadaPay', 'number': '03156717093', 'title': 'Dynetix Official'},
    ];

    for (var m in methods) {
      await _supabase.from('payment_methods').insert({
        'name': m['name'],
        'account_number': m['number'],
        'account_title': m['title'],
        'is_active': true,
      });
    }
  }
}
