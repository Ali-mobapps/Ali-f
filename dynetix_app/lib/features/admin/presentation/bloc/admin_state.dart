part of 'admin_cubit.dart';

abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminLoaded extends AdminState {
  final List<ServiceItemModel> services;
  final List<ServiceItemModel> academyCourses;
  final List<PaymentMethodModel> paymentMethods;

  AdminLoaded({
    required this.services,
    required this.academyCourses,
    required this.paymentMethods,
  });
}
