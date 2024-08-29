import 'package:equatable/equatable.dart';

abstract class MarkOrderState extends Equatable {
  const MarkOrderState();

  @override
  List<Object?> get props => [];
}

class MarkOrderInitial extends MarkOrderState {}

class MarkOrderLoading extends MarkOrderState {}

class MarkOrderPaidSuccess extends MarkOrderState {}

class MarkOrderPaidFailure extends MarkOrderState {
  final String error;

  const MarkOrderPaidFailure(this.error);

  @override
  List<Object?> get props => [error];
}
