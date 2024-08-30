import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/get_revenue/revenue_event.dart';
import 'package:flutter_project_august/blocs/get_revenue/revenue_state.dart';
import 'package:flutter_project_august/models/revenue_model.dart';
import 'package:flutter_project_august/repo/revenue_repo.dart';

class RevenueBloc extends Bloc<RevenueEvent, RevenueState> {
  final RevenueRepo repo;

  RevenueBloc({required this.repo}) : super(RevenueInitial()) {
    on<LoadRevenues>(_onLoadRevenues);
  }

  Future<void> _onLoadRevenues(
      LoadRevenues event, Emitter<RevenueState> emit) async {
    emit(RevenueLoading());
    try {
      final List<Revenue> revenues = await repo.fetchRevenueData(event.year);
      emit(RevenueLoaded(revenues));
    } catch (e) {
      emit(RevenueError(e.toString()));
    }
  }
}
