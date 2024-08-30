// statistic_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/models/statistic_model.dart';
import 'package:flutter_project_august/repo/statistics_repo.dart';

import 'statistic_event.dart';
import 'statistic_state.dart';

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  final StatisticsRepo statisticsRepo;

  StatisticBloc({required this.statisticsRepo}) : super(StatisticInitial()) {
    on<FetchStatistic>(_onFetchStatistic);
  }

  // Inside statistic_bloc.dart

  Future<void> _onFetchStatistic(
      FetchStatistic event, Emitter<StatisticState> emit) async {
    emit(StatisticLoading());
    try {
      final response = await statisticsRepo.getStatisticalData(
          event.startDate, event.endDate);

      final statisticalData = StatisticalData.fromJson(response['data']);

      emit(StatisticLoaded(statisticalData));
    } catch (e) {
      emit(StatisticError(e.toString()));
    }
  }
}
