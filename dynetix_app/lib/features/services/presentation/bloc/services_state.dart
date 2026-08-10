import '../../domain/entities/service_entity.dart';

abstract class ServicesState {}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  final List<ServiceEntity> services;

  ServicesLoaded(this.services);
}

class ServicesError extends ServicesState {
  final String message;

  ServicesError(this.message);
}
