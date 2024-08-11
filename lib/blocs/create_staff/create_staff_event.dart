import 'package:equatable/equatable.dart';

abstract class CreateStaffEvent extends Equatable {
  const CreateStaffEvent();

  @override
  List<Object> get props => [];
}

class CreateStaffRequested extends CreateStaffEvent {
  final String username;
  final String password;
  final String name;

  const CreateStaffRequested({
    required this.username,
    required this.password,
    required this.name,
  });

  @override
  List<Object> get props => [username, password, name];
}
