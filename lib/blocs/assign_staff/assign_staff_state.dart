// assign_staff_state.dart
import 'package:equatable/equatable.dart';

abstract class AssignStaffState extends Equatable {
  const AssignStaffState();

  @override
  List<Object> get props => [];
}

class AssignStaffInitial extends AssignStaffState {}

class AssignStaffLoading extends AssignStaffState {}

class AssignStaffSuccess extends AssignStaffState {}

class AssignStaffFailure extends AssignStaffState {
  final String error;

  const AssignStaffFailure(this.error);

  @override
  List<Object> get props => [error];
}
