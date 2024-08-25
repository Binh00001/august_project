import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_project_august/blocs/create_product/create_product_event.dart';
import 'package:flutter_project_august/blocs/create_product/create_product_state.dart';
import 'package:flutter_project_august/repo/product_repo.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

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
      String? mimeType;
      if (event.imageFile != null) {
        mimeType = lookupMimeType(event.imageFile!.path);
      }
      late bool result;
      FormData formDataInput = FormData.fromMap({
        'name': event.name,
        'unit': event.unit,
        'price': event.price,
        'categoryId': event.categoryId,
        if (event.imageFile != null)
          'images': await MultipartFile.fromFile(
            event.imageFile!.path,
            filename: event.imageFile!.name,
            contentType: mimeType != null ? MediaType.parse(mimeType) : null,
          ),
      });
      result = await productRepo.createProduct(
        formData: formDataInput,
      );
      if (result == true) {
        emit(CreateProductSuccess());
      } else {
        emit(const CreateProductFailure(error: "Tạo thất bại"));
      }
    } catch (error) {
      // print(error);
      emit(CreateProductFailure(error: error.toString()));
    }
  }
}
