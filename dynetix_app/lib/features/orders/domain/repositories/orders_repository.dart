import '../entities/order_entity.dart';

abstract class OrdersRepository {
  Stream<List<OrderEntity>> watchCustomerOrders(String userId);
  Stream<List<OrderEntity>> watchAllOrders();
  Future<void> createOrder(OrderEntity order);
  Future<void> updateOrderStatus(String orderId, String status);
  Future<void> updatePaymentStatus(String orderId, String status, {String? screenshotUrl});
  Future<String> uploadPaymentScreenshot(dynamic file, String orderId);
  Future<void> deleteOrder(String orderId);
}
