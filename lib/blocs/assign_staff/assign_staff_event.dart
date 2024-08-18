// assign_staff_event.dart
import 'package:equatable/equatable.dart';

abstract class AssignStaffEvent extends Equatable {
  const AssignStaffEvent();

  @override
  List<Object> get props => [];
}

class AssignStaffToTaskEvent extends AssignStaffEvent {
  final String userId;
  final String productId;

  const AssignStaffToTaskEvent({required this.userId, required this.productId});

  @override
  List<Object> get props => [userId, productId];
}
