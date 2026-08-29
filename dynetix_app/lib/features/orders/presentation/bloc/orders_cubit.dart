import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/orders_repository.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository repository;
  StreamSubscription? _subscription;

  OrdersCubit(this.repository) : super(OrdersInitial());

  void watchCustomerOrders(String userId) {
    emit(OrdersLoading());
    _subscription?.cancel();
    _subscription = repository.watchCustomerOrders(userId).listen(
      (orders) => emit(OrdersLoaded(orders)),
      onError: (e) => emit(OrdersError(e.toString())),
    );
  }

  void watchAllOrders() {
    emit(OrdersLoading());
    _subscription?.cancel();
    try {
      _subscription = repository.watchAllOrders().listen(
        (orders) {
          print('ADMIN: Received ${orders.length} orders');
          emit(OrdersLoaded(orders));
        },
        onError: (e) {
          print('ADMIN STREAM ERROR: $e');
          emit(OrdersError(e.toString()));
        },
      );
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> createOrder(OrderEntity order) async {
    try {
      await repository.createOrder(order);
      // Stream will automatically pick it up, but we can emit loading briefly if we want
    } catch (e) {
      emit(OrdersError('Failed to book order: ${e.toString()}'));
    }
  }

  Future<void> updateStatus(String orderId, String status) async {
    try {
      await repository.updateOrderStatus(orderId, status);
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> uploadPaymentProof(String orderId, dynamic file) async {
    try {
      final url = await repository.uploadPaymentScreenshot(file, orderId);
      await repository.updatePaymentStatus(orderId, 'pending_verification', screenshotUrl: url);
    } catch (e) {
      emit(OrdersError('Upload failed: $e'));
    }
  }

  Future<void> approvePayment(String orderId) async {
    try {
      await repository.updatePaymentStatus(orderId, 'paid');
      await repository.updateOrderStatus(orderId, 'in_progress');
    } catch (e) {
      emit(OrdersError('Approval failed: $e'));
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await repository.deleteOrder(orderId);
    } catch (e) {
      emit(OrdersError('Delete failed: $e'));
    }
  }

  Future<void> uploadDeliverable(String orderId, dynamic file, String fileName, List<String> currentDeliverables) async {
    try {
      final url = await repository.uploadDeliverable(file, orderId, fileName);
      final updatedList = List<String>.from(currentDeliverables)..add(url);
      await repository.updateDeliverables(orderId, updatedList);
    } catch (e) {
      emit(OrdersError('File upload failed: $e'));
    }
  }

  Future<void> removeDeliverable(String orderId, String url, List<String> currentDeliverables) async {
    try {
      final updatedList = List<String>.from(currentDeliverables)..remove(url);
      await repository.updateDeliverables(orderId, updatedList);
    } catch (e) {
      emit(OrdersError('File removal failed: $e'));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
