import 'package:equatable/equatable.dart';

abstract class ChangePasswordState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {
  final dynamic response; // You can make this more specific

  ChangePasswordSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class ChangePasswordFailure extends ChangePasswordState {
  final String error;

  ChangePasswordFailure(this.error);

  @override
  List<Object> get props => [error];
}
