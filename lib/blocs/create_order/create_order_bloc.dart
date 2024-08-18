// order_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:flutter_project_august/blocs/create_order/create_order_event.dart';
import 'package:flutter_project_august/blocs/create_order/create_order_state.dart';

import 'package:flutter_project_august/repo/order_repo.dart';

class CreateOrderBloc extends Bloc<CreateOrderEvent, CreateOrderState> {
  final OrderRepo orderRepo;

  CreateOrderBloc({required this.orderRepo}) : super(CreateOrderInitial()) {
    on<CreateOrder>(_onCreateOrder);
  }

  Future<void> _onCreateOrder(
      CreateOrder event, Emitter<CreateOrderState> emit) async {
    emit(CreateOrderLoading());

    try {
      final result =
          await orderRepo.createOrder(event.products, event.totalAmount);
      if (result) {
        emit(const CreateOrderSuccess(message: 'Order created successfully.'));
      } else {
        emit(const CreateOrderFailure(error: ""));
      }
    } catch (e) {
      emit(CreateOrderFailure(error: e.toString()));
    }
  }
}
