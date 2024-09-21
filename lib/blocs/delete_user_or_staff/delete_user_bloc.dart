// user_delete_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:flutter_project_august/blocs/delete_user_or_staff/delete_user_event.dart';
import 'package:flutter_project_august/blocs/delete_user_or_staff/delete_user_state.dart';
import 'package:flutter_project_august/repo/user_repo.dart';

class UserDeleteBloc extends Bloc<UserDeleteEvent, UserDeleteState> {
  final UserRepo userRepo;

  UserDeleteBloc({required this.userRepo}) : super(UserDeleteInitial()) {
    on<DeleteUserEvent>(_onDeleteUser);
  }

  Future<void> _onDeleteUser(
    DeleteUserEvent event,
    Emitter<UserDeleteState> emit,
  ) async {
    emit(UserDeleteLoading());
    try {
      await userRepo.deleteUser(event.userId);
      print("deleted usser ${event.userId}");
      emit(UserDeleteSuccess());
    } catch (e) {
      emit(UserDeleteFailure(e.toString()));
    }
  }
}
