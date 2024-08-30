// statistic_state.dart

import 'package:flutter_project_august/models/statistic_model.dart';

abstract class StatisticState {}

class StatisticInitial extends StatisticState {}

class StatisticLoading extends StatisticState {}

class StatisticLoaded extends StatisticState {
  final StatisticalData
      data; // Replace dynamic with a more specific type as necessary
  StatisticLoaded(this.data);
}

class StatisticError extends StatisticState {
  final String message;
  StatisticError(this.message);
}
