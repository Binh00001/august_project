abstract class DebtEvent {}

class FetchDebt extends DebtEvent {
  final String? schoolId;
  final int? startDate;
  final int? endDate;

  FetchDebt({this.schoolId, this.startDate, this.endDate});
}
