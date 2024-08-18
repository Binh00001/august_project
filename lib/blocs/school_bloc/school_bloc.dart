// school_bloc.dart

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_event.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_state.dart';
import 'package:flutter_project_august/models/school_model.dart';
import 'package:flutter_project_august/repo/school_repo.dart';

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final SchoolRepo schoolRepo;

  SchoolBloc({required this.schoolRepo}) : super(SchoolInitial()) {
    on<GetAllSchoolsEvent>(_onGetAllSchools);
  }

  Future<void> _onGetAllSchools(
      GetAllSchoolsEvent event, Emitter<SchoolState> emit) async {
    try {
      emit(SchoolLoading());
      final schools = await schoolRepo.getAllSchools(1, 100);
      final schoolList = schools
          .map((school) => School.fromJson(school))
          .toList(); // Convert List<dynamic> to List<User>
      if (schools.isEmpty) {
        emit(SchoolInitial());
      } else {
        emit(SchoolLoaded(schoolList));
      }
    } catch (e) {
      emit(SchoolError(e.toString()));
    }
  }
}
