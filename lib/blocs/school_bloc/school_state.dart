// school_state.dart

import 'package:flutter_project_august/models/school_model.dart';

abstract class SchoolState {}

class SchoolInitial extends SchoolState {}

class SchoolLoading extends SchoolState {}

class SchoolLoaded extends SchoolState {
  final List<School> schools;
  SchoolLoaded(this.schools);
}

class SchoolError extends SchoolState {
  final String message;
  SchoolError(this.message);
}
