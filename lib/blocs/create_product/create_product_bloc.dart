import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_project_august/blocs/create_product/create_product_event.dart';
import 'package:flutter_project_august/blocs/create_product/create_product_state.dart';
import 'package:flutter_project_august/repo/product_repo.dart';

class CreateProductBloc extends Bloc<CreateProductEvent, CreateProductState> {
  final ProductRepo productRepo;

  CreateProductBloc({required this.productRepo})
      : super(CreateProductInitial()) {
    on<CreateProductRequested>(_onCreateProductRequested);
  }

  Future<void> _onCreateProductRequested(
      CreateProductRequested event, Emitter<CreateProductState> emit) async {
    emit(CreateProductLoading());
    try {
      bool result;
      if (event.imagePath != "" || event.imagePath == null) {
        result = await productRepo.createProduct(
          formData: {
            'name': event.name,
            'unit': event.unit,
            'price': event.price.toString(),
            'categoryId': event.categoryId,
            'originId': event.originId,
            'image': await MultipartFile.fromFile(event.imagePath!),
          },
        );
      } else {
        result = await productRepo.createProduct(
          formData: {
            'name': event.name,
            'unit': event.unit,
            'price': event.price.toString(),
            'categoryId': event.categoryId,
            'originId': event.originId,
          },
        );
      }
      if (result) {
        emit(CreateProductSuccess());
      } else {
        emit(const CreateProductFailure(error: "Tạo thất bại"));
      }
    } catch (error) {
      emit(CreateProductFailure(error: error.toString()));
    }
  }
}
