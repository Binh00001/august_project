// order_state.dart
import 'package:equatable/equatable.dart';

abstract class CreateOrderState extends Equatable {
  const CreateOrderState();

  @override
  List<Object?> get props => [];
}

class CreateOrderInitial extends CreateOrderState {}

class CreateOrderLoading extends CreateOrderState {}

class CreateOrderSuccess extends CreateOrderState {
  final String message;

  const CreateOrderSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class CreateOrderFailure extends CreateOrderState {
  final String error;

  const CreateOrderFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
