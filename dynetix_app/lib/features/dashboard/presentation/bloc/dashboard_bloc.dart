import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboardData>((event, emit) async {
      emit(DashboardLoading());
      try {
        // Yahan future mein API ya Hive database se data fetch hoga
        await Future.delayed(const Duration(milliseconds: 500));
        emit(const DashboardLoaded(balance: 125750.50));
      } catch (e) {
        emit(DashboardError(e.toString()));
      }
    });
  }
}