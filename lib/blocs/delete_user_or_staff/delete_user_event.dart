// user_delete_event.dart
import 'package:equatable/equatable.dart';

abstract class UserDeleteEvent extends Equatable {
  const UserDeleteEvent();

  @override
  List<Object> get props => [];
}

// Event to delete a user by ID
class DeleteUserEvent extends UserDeleteEvent {
  final String userId;

  const DeleteUserEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}
