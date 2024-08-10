import 'package:equatable/equatable.dart';

abstract class CreateSchoolEvent extends Equatable {
  const CreateSchoolEvent();

  @override
  List<Object> get props => [];
}

class CreateSchool extends CreateSchoolEvent {
  final String name;
  final String address;
  final String contactNumber;

  const CreateSchool({
    required this.name,
    required this.address,
    required this.contactNumber,
  });

  @override
  List<Object> get props => [name, address, contactNumber];
}
