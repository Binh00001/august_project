import 'package:equatable/equatable.dart';
import 'package:flutter_project_august/models/staff_model.dart';
import 'package:flutter_project_august/models/task_model.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final Staff staff;
  const TaskLoaded({required this.tasks, required this.staff});

  @override
  List<Object?> get props => [tasks];
}

class TaskError extends TaskState {
  final String message;

  const TaskError({required this.message});

  @override
  List<Object?> get props => [message];
}
