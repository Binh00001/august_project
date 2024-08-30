import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_project_august/blocs/change_password/change_password_event.dart';
import 'package:flutter_project_august/blocs/change_password/change_password_state.dart';
import 'package:flutter_project_august/repo/user_repo.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final UserRepo repo;

  ChangePasswordBloc({required this.repo}) : super(ChangePasswordInitial()) {
    on<ChangePasswordRequested>(_onChangePasswordRequested);
    on<ChangePasswordReset>((event, emit) => emit(ChangePasswordInitial()));
  }

  Future<void> _onChangePasswordRequested(
      ChangePasswordRequested event, Emitter<ChangePasswordState> emit) async {
    emit(ChangePasswordLoading());
    try {
      final response =
          await repo.changePassword(event.oldPassword, event.newPassword);
      print(response);
      print('old ${event.oldPassword}');
      print('new ${event.newPassword}');
      if (response == 200) {
        emit(ChangePasswordSuccess(response));
      } else if (response == 422) {
        emit(ChangePasswordFailure("Mật khẩu cũ không đúng."));
      } else {
        emit(ChangePasswordFailure("Lỗi không xác định."));
      }
    } catch (e) {
      emit(ChangePasswordFailure(e.toString()));
    }
  }
}
