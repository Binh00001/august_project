import 'package:flutter_project_august/models/order_model.dart';

abstract class GetOrderState {}

class GetOrderInitial extends GetOrderState {}

class GetOrderLoading extends GetOrderState {}

class GetOrderLoaded extends GetOrderState {
  final List<Order> orders;

  GetOrderLoaded(this.orders);
}

class GetOrderError extends GetOrderState {
  final String message;

  GetOrderError(this.message);
}
