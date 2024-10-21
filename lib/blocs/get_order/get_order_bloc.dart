import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/get_order/get_order_event.dart';
import 'package:flutter_project_august/blocs/get_order/get_order_state.dart';
import 'package:flutter_project_august/models/order_model.dart';
import 'package:flutter_project_august/repo/order_repo.dart';

class GetOrderBloc extends Bloc<GetOrderEvent, GetOrderState> {
  final OrderRepo orderRepo;

  GetOrderBloc({required this.orderRepo}) : super(GetOrderInitial()) {
    on<FetchOrders>((event, emit) async {
      emit(GetOrderLoading());

      try {
        // Lấy danh sách đơn hàng từ API
        List<Order> newOrders = await orderRepo.getOrders(
          page: event.page,
          pageSize: event.pageSize,
          schoolId: event.schoolId,
          startDate: event.startDate,
          endDate: event.endDate,
        );

        int totalPages = await orderRepo.getTotalPages(
          page: event.page,
          pageSize: event.pageSize,
          schoolId: event.schoolId,
          startDate: event.startDate,
          endDate: event.endDate,
        );

        emit(GetOrderLoaded(
            newOrders, totalPages)); // Emit danh sách đã cập nhật
      } catch (e) {
        emit(GetOrderError(e.toString())); // Emit lỗi nếu có
      }
    });
  }
}
