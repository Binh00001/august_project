// school_delete_event.dart
import 'package:equatable/equatable.dart';

abstract class SchoolDeleteEvent extends Equatable {
  const SchoolDeleteEvent();

  @override
  List<Object?> get props => [];
}

class DeleteSchoolEvent extends SchoolDeleteEvent {
  final String schoolId;

  const DeleteSchoolEvent({required this.schoolId});

  @override
  List<Object?> get props => [schoolId];
}
