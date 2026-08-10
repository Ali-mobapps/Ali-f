import '../../domain/entities/service_entity.dart';
import '../../domain/repositories/services_repository.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final List<ServiceEntity> _services = [
    const ServiceEntity(
      id: '1',
      title: 'Mobile App Development',
      description: 'Cross-platform apps using Flutter & modern tech.',
      price: 500.0,
      type: 'Service',
    ),
    const ServiceEntity(
      id: '2',
      title: 'UI/UX Design Masterclass',
      description: 'Learn professional UI/UX design from scratch.',
      price: 150.0,
      type: 'Course',
    ),
  ];

  @override
  Future<List<ServiceEntity>> getServices() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _services;
  }

  @override
  Future<void> addService(ServiceEntity service) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _services.add(service);
  }

  @override
  Future<void> deleteService(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _services.removeWhere((element) => element.id == id);
  }
}
