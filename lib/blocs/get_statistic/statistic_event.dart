// statistic_event.dart

abstract class StatisticEvent {}

class FetchStatistic extends StatisticEvent {
  final int startDate;
  final int endDate;

  FetchStatistic({required this.startDate, required this.endDate});
}
