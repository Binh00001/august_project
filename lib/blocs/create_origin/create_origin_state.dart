import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CreateOriginState extends Equatable {
  const CreateOriginState();

  @override
  List<Object> get props => [];
}

class CreateOriginInitial extends CreateOriginState {}

class CreateOriginLoading extends CreateOriginState {}

class CreateOriginSuccess extends CreateOriginState {}

class CreateOriginFailure extends CreateOriginState {
  final String error;

  const CreateOriginFailure({required this.error});

  @override
  List<Object> get props => [error];
}
