import 'package:equatable/equatable.dart';

abstract class CreateUserEvent extends Equatable {
  const CreateUserEvent();

  @override
  List<Object> get props => [];
}

class CreateNewUser extends CreateUserEvent {
  final String username;
  final String password;
  final String name;
  final String schoolId;

  const CreateNewUser({
    required this.username,
    required this.password,
    required this.name,
    required this.schoolId,
  });

  @override
  List<Object> get props => [username, password, name, schoolId];
}
