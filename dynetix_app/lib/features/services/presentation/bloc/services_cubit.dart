import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/repositories/services_repository.dart';
import 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final ServicesRepository repository;

  ServicesCubit(this.repository) : super(ServicesInitial());

  Future<void> fetchServices() async {
    emit(ServicesLoading());
    try {
      final services = await repository.getServices();
      emit(ServicesLoaded(services));
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }

  Future<void> addService(ServiceEntity service) async {
    try {
      await repository.addService(service);
      fetchServices();
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }

  Future<void> updateService(ServiceEntity service) async {
    try {
      await repository.updateService(service);
      fetchServices();
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }

  Future<void> deleteService(String id) async {
    try {
      await repository.deleteService(id);
      fetchServices();
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }
}
