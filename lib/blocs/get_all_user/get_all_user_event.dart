import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUsers extends UserEvent {
  final String? schoolId;

  const FetchUsers({this.schoolId});

  @override
  List<Object?> get props => [schoolId];
}
