import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_project_august/blocs/update_product/update_product_event.dart';
import 'package:flutter_project_august/blocs/update_product/update_product_state.dart';
import 'package:flutter_project_august/repo/product_repo.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

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
      FormData formData = FormData();

      // Add 'name' if not null and not empty
      if (event.name != null && event.name!.isNotEmpty) {
        formData.fields.add(MapEntry("name", event.name!));
      }

      // Add 'price' if not null and not empty
      if (event.price != null && event.price!.isNotEmpty) {
        formData.fields.add(MapEntry("price", event.price!));
      }

      // Add 'productId' if not null and not empty
      formData.fields.add(MapEntry("productId", event.productId));

      // Handle image file if not null
      if (event.imageFile != null) {
        String? mimeType = lookupMimeType(event.imageFile!.path);
        MediaType? mediaType =
            mimeType != null ? MediaType.parse(mimeType) : null;

        formData.files.add(MapEntry(
          "images",
          await MultipartFile.fromFile(
            event.imageFile!.path,
            filename: event.imageFile!.name,
            contentType: mediaType,
          ),
        ));
      }

      // Call the repository to update the product
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
