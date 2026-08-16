import '../entities/payment_method_entity.dart';

abstract class PaymentMethodsRepository {
  Future<List<PaymentMethodEntity>> getPaymentMethods();
  Future<void> addPaymentMethod(PaymentMethodEntity method);
  Future<void> updatePaymentMethod(PaymentMethodEntity method);
  Future<void> deletePaymentMethod(String id);
  Future<void> seedInitialMethods();
}
