// assign_staff_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/repo/order_repo.dart';
import 'assign_staff_event.dart';
import 'assign_staff_state.dart';

class AssignStaffBloc extends Bloc<AssignStaffEvent, AssignStaffState> {
  final OrderRepo orderRepo;

  AssignStaffBloc({required this.orderRepo}) : super(AssignStaffInitial()) {
    on<AssignStaffToTaskEvent>(_onAssignStaffToTask);
  }

  Future<void> _onAssignStaffToTask(
    AssignStaffToTaskEvent event,
    Emitter<AssignStaffState> emit,
  ) async {
    emit(AssignStaffLoading());
    try {
      await orderRepo.assignStaffToTask(event.userId, event.productId);
      emit(AssignStaffSuccess());
    } catch (e) {
      emit(AssignStaffFailure(e.toString()));
    }
  }
}
