import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/create_category/create_category_event.dart';
import 'package:flutter_project_august/blocs/create_category/create_category_state.dart';
import 'package:flutter_project_august/repo/category_repo.dart';

class CreateCategoryBloc
    extends Bloc<CreateCategoryEvent, CreateCategoryState> {
  final CategoryRepo categoryRepo;

  CreateCategoryBloc({required this.categoryRepo})
      : super(CreateCategoryInitial()) {
    on<CreateCategoryRequested>(_onCreateCategoryRequested);
  }

  Future<void> _onCreateCategoryRequested(
      CreateCategoryRequested event, Emitter<CreateCategoryState> emit) async {
    emit(CreateCategoryLoading());
    try {
      final success = await categoryRepo.createCategory(
        name: event.name,
      );
      if (success) {
        emit(CreateCategorySuccess());
      } else {
        emit(CreateCategoryFailure(error: 'Failed to create category.'));
      }
    } catch (e) {
      emit(CreateCategoryFailure(error: e.toString()));
    }
  }
}
