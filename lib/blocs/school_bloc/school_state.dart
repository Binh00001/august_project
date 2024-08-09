// school_state.dart

abstract class SchoolState {}

class SchoolInitial extends SchoolState {}

class SchoolLoading extends SchoolState {}

class SchoolLoaded extends SchoolState {
  final List<Map<String, dynamic>> schools;
  SchoolLoaded(this.schools);
}

class SchoolError extends SchoolState {
  final String message;
  SchoolError(this.message);
}
