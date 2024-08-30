import 'package:flutter_project_august/models/revenue_model.dart';

abstract class RevenueState {}

class RevenueInitial extends RevenueState {}

class RevenueLoading extends RevenueState {}

class RevenueLoaded extends RevenueState {
  final List<Revenue> revenues;
  RevenueLoaded(this.revenues);
}

class RevenueError extends RevenueState {
  final String message;
  RevenueError(this.message);
}
