abstract class GetOrderEvent {}

class FetchOrders extends GetOrderEvent {
  final int page;
  final int pageSize;
  final String? schoolId;
  final int? startDate;
  final int? endDate;

  FetchOrders(
      {required this.page,
      required this.pageSize,
      this.schoolId,
      this.startDate,
      this.endDate});
}
