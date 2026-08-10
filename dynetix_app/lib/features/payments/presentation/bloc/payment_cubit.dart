import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/payment_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository repository;

  PaymentCubit(this.repository) : super(PaymentInitial());

  Future<void> fetchPayments() async {
    emit(PaymentLoading());
    try {
      final payments = await repository.getPayments();
      emit(PaymentLoaded(payments));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }

  Future<void> makePayment(PaymentEntity payment) async {
    emit(PaymentLoading());
    try {
      await repository.processPayment(payment);
      emit(PaymentSuccessState('Payment processed successfully!'));
      final payments = await repository.getPayments();
      emit(PaymentLoaded(payments));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }
}
