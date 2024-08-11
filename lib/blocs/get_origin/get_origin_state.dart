import 'package:equatable/equatable.dart';
import 'package:flutter_project_august/models/product_model.dart';

abstract class OriginState extends Equatable {
  const OriginState();

  @override
  List<Object> get props => [];
}

class OriginInitial extends OriginState {}

class OriginLoading extends OriginState {}

class OriginLoaded extends OriginState {
  final List<Origin> origins;

  const OriginLoaded({required this.origins});

  @override
  List<Object> get props => [origins];
}

class OriginError extends OriginState {
  final String message;

  const OriginError({required this.message});

  @override
  List<Object> get props => [message];
}
