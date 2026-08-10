import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  // Temporary in-memory payment history list
  final List<PaymentEntity> _payments = [
    PaymentEntity(
      id: 'pay_1',
      itemTitle: 'Flutter Mobile App Development',
      amount: 150.0,
      status: 'Success',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Future<List<PaymentEntity>> getPayments() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _payments;
  }

  @override
  Future<void> processPayment(PaymentEntity payment) async {
    await Future.delayed(
        const Duration(milliseconds: 800)); // Simulating gateway delay
    _payments.insert(0, payment);
  }
}
