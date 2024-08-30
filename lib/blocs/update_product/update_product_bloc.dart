import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_project_august/blocs/update_product/update_product_event.dart';
import 'package:flutter_project_august/blocs/update_product/update_product_state.dart';
import 'package:flutter_project_august/repo/product_repo.dart';

class UpdateProductBloc extends Bloc<UpdateProductEvent, UpdateProductState> {
  final ProductRepo productRepo;

  UpdateProductBloc({required this.productRepo})
      : super(UpdateProductInitial()) {
    on<UpdateProductButtonPressed>(_onUpdateProduct);
  }

  Future<void> _onUpdateProduct(UpdateProductButtonPressed event,
      Emitter<UpdateProductState> emit) async {
    emit(UpdateProductLoading());
    try {
      FormData formData = FormData.fromMap({
        'name': event.name,
        'price': event.price,
        'image': await MultipartFile.fromFile(event.imageFile),
      });

      bool success = await productRepo.updateProduct(formData: formData);
      if (success) {
        emit(UpdateProductSuccess());
      } else {
        emit(UpdateProductFailure(error: "Failed to update product."));
      }
    } catch (e) {
      emit(UpdateProductFailure(error: e.toString()));
    }
  }
}
