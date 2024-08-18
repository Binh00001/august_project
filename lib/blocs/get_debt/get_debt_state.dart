abstract class DebtState {}

class DebtInitial extends DebtState {}

class DebtLoading extends DebtState {}

class DebtLoaded extends DebtState {
  final num debts;

  DebtLoaded({required this.debts});
}

class DebtError extends DebtState {
  final String message;

  DebtError({required this.message});
}
