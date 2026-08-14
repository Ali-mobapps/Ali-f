import '../../domain/entities/payment_method_entity.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}
class PaymentLoading extends PaymentState {}
class PaymentLoaded extends PaymentState {
  final List<PaymentMethodEntity> payments;
  PaymentLoaded({required this.payments});
}
class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message);
}
