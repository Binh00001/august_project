// update_category_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/repo/category_repo.dart';
import 'update_category_event.dart';
import 'update_category_state.dart';

class UpdateCategoryBloc
    extends Bloc<UpdateCategoryEvent, UpdateCategoryState> {
  final CategoryRepo categoryRepo;

  UpdateCategoryBloc({required this.categoryRepo})
      : super(UpdateCategoryInitial()) {
    on<UpdateCategoryName>(_onUpdateCategoryName);
  }

  Future<void> _onUpdateCategoryName(
    UpdateCategoryName event,
    Emitter<UpdateCategoryState> emit,
  ) async {
    emit(UpdateCategoryLoading());
    try {
      bool updated = await categoryRepo.updateCategory(event.id, event.newName);
      if (updated) {
        emit(UpdateCategorySuccess(true));
      } else {
        emit(UpdateCategoryFailure('Failed to update the category name.'));
      }
    } catch (e) {
      emit(UpdateCategoryFailure(e.toString()));
    }
  }
}
