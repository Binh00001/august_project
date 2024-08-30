// delete_product_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/repo/product_repo.dart';
import 'delete_product_event.dart';
import 'delete_product_state.dart';

class DeleteProductBloc extends Bloc<DeleteProductEvent, DeleteProductState> {
  final ProductRepo productRepo;

  DeleteProductBloc({required this.productRepo})
      : super(DeleteProductInitial()) {
    on<DeleteProduct>(_onDeleteProduct);
  }

  Future<void> _onDeleteProduct(
      DeleteProduct event, Emitter<DeleteProductState> emit) async {
    emit(DeleteProductLoading());
    try {
      bool isSuccess = await productRepo.deleteProduct(event.productId);
      if (isSuccess) {
        emit(DeleteProductSuccess());
      } else {
        emit(DeleteProductFailure('Failed to delete the product'));
      }
    } catch (e) {
      emit(DeleteProductFailure(e.toString()));
    }
  }
}
