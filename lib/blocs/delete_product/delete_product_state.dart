// delete_product_state.dart

abstract class DeleteProductState {}

class DeleteProductInitial extends DeleteProductState {}

class DeleteProductLoading extends DeleteProductState {}

class DeleteProductSuccess extends DeleteProductState {}

class DeleteProductFailure extends DeleteProductState {
  final String error;

  DeleteProductFailure(this.error);
}
