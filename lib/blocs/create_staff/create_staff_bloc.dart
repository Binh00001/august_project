import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/repo/user_repo.dart';
import 'create_staff_event.dart';
import 'create_staff_state.dart';

class CreateStaffBloc extends Bloc<CreateStaffEvent, CreateStaffState> {
  final UserRepo userRepo;

  CreateStaffBloc({required this.userRepo}) : super(CreateStaffInitial()) {
    on<CreateStaffRequested>(_onCreateStaffRequested);
  }

  void _onCreateStaffRequested(
      CreateStaffRequested event, Emitter<CreateStaffState> emit) async {
    emit(CreateStaffLoading());
    try {
      await userRepo.createNewStaff(
        username: event.username,
        password: event.password,
        name: event.name,
      );
      emit(CreateStaffSuccess());
    } catch (e) {
      emit(CreateStaffError(error: e.toString()));
    }
  }
}
