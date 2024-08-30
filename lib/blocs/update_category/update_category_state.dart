// update_category_state.dart

abstract class UpdateCategoryState {}

class UpdateCategoryInitial extends UpdateCategoryState {}

class UpdateCategoryLoading extends UpdateCategoryState {}

class UpdateCategorySuccess extends UpdateCategoryState {
  final bool success;

  UpdateCategorySuccess(this.success);
}

class UpdateCategoryFailure extends UpdateCategoryState {
  final String error;

  UpdateCategoryFailure(this.error);
}
