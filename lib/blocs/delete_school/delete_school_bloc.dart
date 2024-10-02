// school_delete_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:flutter_project_august/blocs/delete_school/delete_school_event.dart';
import 'package:flutter_project_august/blocs/delete_school/delete_school_state.dart';
import 'package:flutter_project_august/repo/school_repo.dart';

class SchoolDeleteBloc extends Bloc<SchoolDeleteEvent, SchoolDeleteState> {
  final SchoolRepo schoolRepo;

  SchoolDeleteBloc({required this.schoolRepo}) : super(SchoolDeleteInitial()) {
    on<DeleteSchoolEvent>(_onDeleteSchool);
  }

  Future<void> _onDeleteSchool(
    DeleteSchoolEvent event,
    Emitter<SchoolDeleteState> emit,
  ) async {
    emit(SchoolDeleteLoading());
    try {
      await schoolRepo.deleteSchool(event.schoolId);
      print("deleted school ${event.schoolId}");
      emit(SchoolDeleteSuccess());
    } catch (e) {
      emit(SchoolDeleteFailure(e.toString()));
    }
  }
}
