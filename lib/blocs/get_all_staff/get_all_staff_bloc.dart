import 'package:bloc/bloc.dart';
import 'package:flutter_project_august/blocs/get_all_staff/get_all_staff_event.dart';
import 'package:flutter_project_august/blocs/get_all_staff/get_all_staff_state.dart';
import 'package:flutter_project_august/models/staff_model.dart';

import 'package:flutter_project_august/repo/user_repo.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  final UserRepo userRepo;

  StaffBloc({required this.userRepo}) : super(StaffInitial()) {
    on<FetchStaff>(_onFetchStaff);
  }

  void _onFetchStaff(FetchStaff event, Emitter<StaffState> emit) async {
    emit(StaffLoading());
    try {
      final userList =
          await userRepo.getUsersByRoleAndSchool('staff', event.schoolId, 1);
      final staff = userList
          .map((user) => Staff.fromJson(user))
          .toList(); // Convert List<dynamic> to List<User>
      emit(StaffLoaded(staff: staff));
    } catch (e) {
      emit(StaffError(message: e.toString()));
    }
  }
}
