import 'package:equatable/equatable.dart';

abstract class CreateUserState extends Equatable {
  const CreateUserState();

  @override
  List<Object> get props => [];
}

class CreateUserInitial extends CreateUserState {}

class CreateUserLoading extends CreateUserState {}

class CreateUserSuccess extends CreateUserState {}

class CreateUserError extends CreateUserState {
  final String message;

  const CreateUserError({required this.message});

  @override
  List<Object> get props => [message];
}
