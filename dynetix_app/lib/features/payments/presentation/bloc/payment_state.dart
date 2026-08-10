import '../../domain/entities/payment_entity.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final List<PaymentEntity> payments;

  PaymentLoaded(this.payments);
}

class PaymentSuccessState extends PaymentState {
  final String message;

  PaymentSuccessState(this.message);
}

class PaymentError extends PaymentState {
  final String message;

  PaymentError(this.message);
}
