import '../entities/payment_entity.dart';

abstract class PaymentRepository {
  Future<List<PaymentEntity>> getPayments();

  Future<void> processPayment(PaymentEntity payment);
}