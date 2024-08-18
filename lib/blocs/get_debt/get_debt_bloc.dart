import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/get_debt/get_debt_event.dart';
import 'package:flutter_project_august/blocs/get_debt/get_debt_state.dart';
import 'package:flutter_project_august/repo/order_repo.dart';

class DebtBloc extends Bloc<DebtEvent, DebtState> {
  final OrderRepo orderRepo;

  DebtBloc({required this.orderRepo}) : super(DebtInitial()) {
    on<FetchDebt>(_onFetchDebt);
  }

  Future<void> _onFetchDebt(FetchDebt event, Emitter<DebtState> emit) async {
    emit(DebtLoading());
    try {
      // Build query parameters based on provided values
      Map<String, dynamic> params = {};
      if (event.schoolId != null) params['schoolId'] = event.schoolId;
      if (event.startDate != null) params['startDate'] = event.startDate;
      if (event.endDate != null) params['endDate'] = event.endDate;
      print(params);
      final debts = await orderRepo.getDebtOrders(params);
      emit(DebtLoaded(debts: debts));
    } catch (e) {
      emit(DebtError(message: e.toString()));
    }
  }
}
