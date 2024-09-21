// user_delete_state.dart
import 'package:equatable/equatable.dart';

abstract class UserDeleteState extends Equatable {
  const UserDeleteState();

  @override
  List<Object> get props => [];
}

// Initial state
class UserDeleteInitial extends UserDeleteState {}

// State when deletion is in progress
class UserDeleteLoading extends UserDeleteState {}

// State when deletion is successful
class UserDeleteSuccess extends UserDeleteState {}

// State when deletion fails
class UserDeleteFailure extends UserDeleteState {
  final String error;

  const UserDeleteFailure(this.error);

  @override
  List<Object> get props => [error];
}
