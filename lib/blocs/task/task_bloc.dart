import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/task/task_event.dart';
import 'package:flutter_project_august/blocs/task/task_state.dart';
import 'package:flutter_project_august/repo/order_repo.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final OrderRepo orderRepo;

  TaskBloc({required this.orderRepo}) : super(TaskInitial()) {
    on<FetchTasks>(_onFetchTasks);
  }

  Future<void> _onFetchTasks(FetchTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await orderRepo.getTasks(event.date, event.schoolId);
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }
}
