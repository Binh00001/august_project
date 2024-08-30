import 'package:equatable/equatable.dart';

abstract class ChangePasswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChangePasswordRequested extends ChangePasswordEvent {
  final String oldPassword;
  final String newPassword;

  ChangePasswordRequested(
      {required this.oldPassword, required this.newPassword});

  @override
  List<Object> get props => [oldPassword, newPassword];
}

class ChangePasswordReset extends ChangePasswordEvent {}
