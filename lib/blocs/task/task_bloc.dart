import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/task/task_event.dart';
import 'package:flutter_project_august/blocs/task/task_state.dart';
import 'package:flutter_project_august/repo/order_repo.dart';
import 'package:flutter_project_august/utill/app_constants.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final OrderRepo orderRepo;

  TaskBloc({required this.orderRepo}) : super(TaskInitial()) {
    on<FetchTasks>(_onFetchTasks);
  }

  Future<void> _onFetchTasks(FetchTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await orderRepo.getTasks(event.date, event.schoolId);
      final staff =
          await orderRepo.getAssignedStaff(event.date, event.schoolId);

      if (staff != null) {
        print(staff.name);
        emit(TaskLoaded(tasks: tasks, staff: staff));
      } else {
        emit(TaskLoaded(tasks: tasks, staff: AppConstants.defaultStaff));
      }
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }
}
