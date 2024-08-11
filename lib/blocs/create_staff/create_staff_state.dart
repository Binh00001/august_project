import 'package:equatable/equatable.dart';

abstract class CreateStaffState extends Equatable {
  const CreateStaffState();

  @override
  List<Object> get props => [];
}

class CreateStaffInitial extends CreateStaffState {}

class CreateStaffLoading extends CreateStaffState {}

class CreateStaffSuccess extends CreateStaffState {}

class CreateStaffError extends CreateStaffState {
  final String error;

  const CreateStaffError({required this.error});

  @override
  List<Object> get props => [error];
}
