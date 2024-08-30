abstract class UpdateProductState {}

class UpdateProductInitial extends UpdateProductState {}

class UpdateProductLoading extends UpdateProductState {}

class UpdateProductSuccess extends UpdateProductState {}

class UpdateProductFailure extends UpdateProductState {
  final String error;

  UpdateProductFailure({required this.error});
}
