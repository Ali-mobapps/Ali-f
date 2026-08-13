import '../entities/payment_method_entity.dart';

abstract class PaymentMethodsRepository {
  Future<List<PaymentMethodEntity>> getPaymentMethods();
  Future<void> updatePaymentMethod(PaymentMethodEntity method);
  Future<void> addPaymentMethod(PaymentMethodEntity method);
}
