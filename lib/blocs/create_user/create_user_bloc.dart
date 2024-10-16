import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/create_user/create_user_event.dart';
import 'package:flutter_project_august/blocs/create_user/create_user_state.dart';

import 'package:flutter_project_august/repo/user_repo.dart';

class CreateUserBloc extends Bloc<CreateUserEvent, CreateUserState> {
  final UserRepo userRepo;

  CreateUserBloc({required this.userRepo}) : super(CreateUserInitial()) {
    on<CreateNewUser>(_onCreateUser);
  }
  void _onCreateUser(CreateNewUser event, Emitter<CreateUserState> emit) async {
    emit(CreateUserLoading());
    try {
      await userRepo.createNewUser(
        username: event.username,
        password: event.password,
        name: event.name,
        schoolId: event.schoolId,
      );
      emit(CreateUserSuccess());
    } catch (e) {
      String errorMessage;

      if (e is Exception) {
        // Lấy message từ Exception mà không hiển thị "Exception: "
        errorMessage = e.toString().replaceAll('Exception: ', '');
      } else {
        // Nếu lỗi không phải là Exception thì hiển thị thông báo chung
        errorMessage = "Đã xảy ra lỗi. Vui lòng thử lại.";
      }

      emit(CreateUserError(message: errorMessage));
    }
  }
}
