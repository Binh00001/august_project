import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class FetchTasks extends TaskEvent {
  final int date;
  final String schoolId;
  const FetchTasks({required this.date, required this.schoolId});

  @override
  List<Object?> get props => [date, schoolId];
}
