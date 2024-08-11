import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CreateCategoryState extends Equatable {
  const CreateCategoryState();

  @override
  List<Object> get props => [];
}

class CreateCategoryInitial extends CreateCategoryState {}

class CreateCategoryLoading extends CreateCategoryState {}

class CreateCategorySuccess extends CreateCategoryState {}

class CreateCategoryFailure extends CreateCategoryState {
  final String error;

  const CreateCategoryFailure({required this.error});

  @override
  List<Object> get props => [error];
}
