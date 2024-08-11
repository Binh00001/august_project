import 'package:bloc/bloc.dart';
import 'package:flutter_project_august/blocs/get_product/get_product_event.dart';
import 'package:flutter_project_august/blocs/get_product/get_product_state.dart';
import 'package:flutter_project_august/repo/product_repo.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepo productRepo;

  ProductBloc({required this.productRepo}) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(
      FetchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final result = await productRepo.getAllProducts(
        event.page,
        event.pageSize,
        event.categoryId,
        event.originId,
      );
      final products = result['products'];
      final totalItems = result['totalItems'] as int;
      final totalPages = result['totalPages'] as int;

      emit(ProductLoaded(
        products: products,
        totalItems: totalItems,
        totalPages: totalPages,
      ));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }
}
