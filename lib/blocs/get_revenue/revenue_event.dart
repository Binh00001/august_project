abstract class RevenueEvent {}

class LoadRevenues extends RevenueEvent {
  final int year;

  LoadRevenues({required this.year});
}
