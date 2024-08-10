import 'package:equatable/equatable.dart';

abstract class CreateSchoolState extends Equatable {
  const CreateSchoolState();

  @override
  List<Object> get props => [];
}

class CreateSchoolInitial extends CreateSchoolState {}

class CreateSchoolLoading extends CreateSchoolState {}

class CreateSchoolSuccess extends CreateSchoolState {
  final String message;

  const CreateSchoolSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class CreateSchoolFailure extends CreateSchoolState {
  final String error;

  const CreateSchoolFailure(this.error);

  @override
  List<Object> get props => [error];
}
