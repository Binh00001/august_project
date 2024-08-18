import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class FetchTasks extends TaskEvent {
  final int date;

  const FetchTasks({required this.date});

  @override
  List<Object?> get props => [date];
}
