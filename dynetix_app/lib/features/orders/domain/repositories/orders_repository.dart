import '../entities/order_entity.dart';

abstract class OrdersRepository {
  Stream<List<OrderEntity>> watchCustomerOrders(String userId);
  Stream<List<OrderEntity>> watchAllOrders();
  Future<void> createOrder(OrderEntity order);
  Future<void> updateOrderStatus(String orderId, String status);
  Future<void> updatePaymentStatus(String orderId, String status, {String? screenshotUrl});
  Future<String> uploadPaymentScreenshot(dynamic file, String orderId);
  Future<String> uploadDeliverable(dynamic file, String orderId, String fileName);
  Future<void> updateDeliverables(String orderId, List<String> urls);
  Future<void> deleteOrder(String orderId);
}
