import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/mark_paid_order/mark_paid_event.dart';
import 'package:flutter_project_august/blocs/mark_paid_order/mark_paid_state.dart';
import 'package:flutter_project_august/repo/order_repo.dart';

class MarkOrderBloc extends Bloc<MarkOrderEvent, MarkOrderState> {
  final OrderRepo orderRepo;

  MarkOrderBloc({required this.orderRepo}) : super(MarkOrderInitial()) {
    on<MarkOrderAsPaidEvent>(_onMarkOrderAsPaid);
  }

  Future<void> _onMarkOrderAsPaid(
      MarkOrderAsPaidEvent event, Emitter<MarkOrderState> emit) async {
    emit(MarkOrderLoading());
    try {
      final success = await orderRepo.markOrderAsPaid(event.orderId);
      if (success) {
        emit(MarkOrderPaidSuccess());
      } else {
        emit(const MarkOrderPaidFailure(
            'Thất bại! Xảy ra lỗi khi xử lý yêu cầu.'));
      }
    } catch (e) {
      emit(MarkOrderPaidFailure(e.toString()));
    }
  }
}
