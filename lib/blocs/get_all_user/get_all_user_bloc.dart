import 'package:bloc/bloc.dart';
import 'package:flutter_project_august/blocs/get_all_user/get_all_user_event.dart';
import 'package:flutter_project_august/blocs/get_all_user/get_all_user_state.dart';
import 'package:flutter_project_august/models/user_model.dart';
import 'package:flutter_project_august/repo/user_repo.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepo userRepo;

  UserBloc({required this.userRepo}) : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
  }

  void _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final userList =
          await userRepo.getUsersByRoleAndSchool('user', event.schoolId, 1);
      final users = userList
          .map((user) => User.fromJson(user))
          .toList(); // Convert List<dynamic> to List<User>
      emit(UserLoaded(users: users));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }
}
