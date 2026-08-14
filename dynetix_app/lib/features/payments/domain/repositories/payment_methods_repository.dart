import '../entities/payment_method_entity.dart';

abstract class PaymentMethodsRepository {
  Future<List<PaymentMethodEntity>> getPaymentMethods();
  Future<void> addPaymentMethod(PaymentMethodEntity method);
  Future<void> updatePaymentMethod(PaymentMethodEntity method);
  Future<void> seedInitialMethods();
}
