import 'package:equatable/equatable.dart';

abstract class StaffEvent extends Equatable {
  const StaffEvent();

  @override
  List<Object?> get props => [];
}

class FetchStaff extends StaffEvent {
  final String? schoolId;

  const FetchStaff({this.schoolId});

  @override
  List<Object?> get props => [schoolId];
}
