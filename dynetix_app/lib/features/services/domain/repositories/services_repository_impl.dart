import '../../domain/entities/service_entity.dart';
import '../../domain/repositories/services_repository.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  // Temporary in-memory list for testing
  final List<ServiceEntity> _services = [
    const ServiceEntity(
      id: '1',
      title: 'Flutter Mobile App Development',
      description: 'Professional cross-platform mobile app development.',
      price: 500.0,
      type: 'service',
    ),
    const ServiceEntity(
      id: '2',
      title: 'Complete Flutter & Dart Bootcamp',
      description: 'Learn app development from scratch to advanced level.',
      price: 150.0,
      type: 'course',
    ),
  ];

  @override
  Future<List<ServiceEntity>> getServices() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _services;
  }

  @override
  Future<void> addService(ServiceEntity service) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _services.add(service);
  }
}
