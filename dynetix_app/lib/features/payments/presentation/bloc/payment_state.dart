import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/payment_method_entity.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentLoaded extends PaymentState {
  final List<PaymentEntity> transactions;
  final List<PaymentMethodEntity> payments; // repurposing name for UI consistency

  PaymentLoaded({this.transactions = const [], this.payments = const []});
}

class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message);
}

class PaymentSuccessState extends PaymentState {
  final String message;
  PaymentSuccessState(this.message);
}
