import 'package:equatable/equatable.dart';
import 'package:flutter_project_august/models/user_model.dart';

abstract class StaffState extends Equatable {
  const StaffState();

  @override
  List<Object?> get props => [];
}

class StaffInitial extends StaffState {}

class StaffLoading extends StaffState {}

class StaffLoaded extends StaffState {
  final List<User> staff;

  const StaffLoaded({required this.staff});

  @override
  List<Object?> get props => [staff];
}

class StaffError extends StaffState {
  final String message;

  const StaffError({required this.message});

  @override
  List<Object?> get props => [message];
}
