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
    emit(ServicesLoading());
    try {
      await repository.addService(service);
      final services = await repository.getServices();
      emit(ServicesLoaded(services));
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }
}
