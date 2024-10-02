// school_delete_state.dart
import 'package:equatable/equatable.dart';

abstract class SchoolDeleteState extends Equatable {
  const SchoolDeleteState();

  @override
  List<Object?> get props => [];
}

class SchoolDeleteInitial extends SchoolDeleteState {}

class SchoolDeleteLoading extends SchoolDeleteState {}

class SchoolDeleteSuccess extends SchoolDeleteState {}

class SchoolDeleteFailure extends SchoolDeleteState {
  final String error;

  const SchoolDeleteFailure(this.error);

  @override
  List<Object?> get props => [error];
}
