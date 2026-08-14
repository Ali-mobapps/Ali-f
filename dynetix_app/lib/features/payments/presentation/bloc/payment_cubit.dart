import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/payment_methods_repository.dart';
import '../../domain/entities/payment_method_entity.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentMethodsRepository methodsRepository;

  PaymentCubit(this.methodsRepository) : super(PaymentInitial());

  Future<void> fetchPaymentMethods() async {
    emit(PaymentLoading());
    try {
      final methods = await methodsRepository.getPaymentMethods();
      emit(PaymentLoaded(payments: methods));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }

  Future<void> addPaymentMethod(PaymentMethodEntity method) async {
    try {
      await methodsRepository.addPaymentMethod(method);
      fetchPaymentMethods();
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }

  Future<void> updatePaymentMethod(PaymentMethodEntity method) async {
    try {
      await methodsRepository.updatePaymentMethod(method);
      fetchPaymentMethods();
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }
}
