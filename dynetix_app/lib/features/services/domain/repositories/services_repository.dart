import '../entities/service_entity.dart';

abstract class ServicesRepository {
  Future<List<ServiceEntity>> getServices();
  Future<void> addService(ServiceEntity service);
  Future<void> updateService(ServiceEntity service);
  Future<void> deleteService(String id);
  Future<void> seedInitialData();
}
