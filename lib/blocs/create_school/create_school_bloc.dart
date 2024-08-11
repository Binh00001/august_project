import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/create_school/create_school_event.dart';
import 'package:flutter_project_august/blocs/create_school/create_school_state.dart';
import 'package:flutter_project_august/repo/school_repo.dart';

class CreateSchoolBloc extends Bloc<CreateSchoolEvent, CreateSchoolState> {
  final SchoolRepo schoolRepo;

  CreateSchoolBloc({required this.schoolRepo}) : super(CreateSchoolInitial()) {
    on<CreateSchool>(_onCreateSchool);
  }

  Future<void> _onCreateSchool(
      CreateSchool event, Emitter<CreateSchoolState> emit) async {
    try {
      emit(CreateSchoolLoading());
      // Create a map to hold the non-null and non-empty parameters
      final Map<String, String> data = {};

      if (event.name.isNotEmpty) {
        data['name'] = event.name;
      }
      if (event.address.isNotEmpty) {
        data['address'] = event.address;
      }
      if (event.contactNumber.isNotEmpty) {
        data['contact_number'] = event.contactNumber;
      }

      // If data is empty, emit a failure state
      if (data.isEmpty) {
        emit(const CreateSchoolFailure('Hãy điền tên trường học.'));
        return;
      }

      // Call the repository function with the non-null, non-empty data
      final response = await schoolRepo.createSchool(dataForm: data);

      if (response.statusCode == 200) {
        emit(const CreateSchoolSuccess('Thêm trường mới thành công'));
      } else {
        emit(const CreateSchoolFailure('Thêm trường thất bại'));
      }
    } catch (e) {
      emit(CreateSchoolFailure(e.toString()));
    }
  }
}
