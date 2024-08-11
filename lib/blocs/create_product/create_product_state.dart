import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CreateProductState extends Equatable {
  const CreateProductState();

  @override
  List<Object> get props => [];
}

class CreateProductInitial extends CreateProductState {}

class CreateProductLoading extends CreateProductState {}

class CreateProductSuccess extends CreateProductState {}

class CreateProductFailure extends CreateProductState {
  final String error;

  const CreateProductFailure({required this.error});

  @override
  List<Object> get props => [error];
}
