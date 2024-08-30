// update_category_event.dart

abstract class UpdateCategoryEvent {}

class UpdateCategoryName extends UpdateCategoryEvent {
  final String id;
  final String newName;

  UpdateCategoryName({required this.id, required this.newName});
}
