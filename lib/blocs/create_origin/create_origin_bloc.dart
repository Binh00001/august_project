import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/create_origin/create_origin_event.dart';
import 'package:flutter_project_august/blocs/create_origin/create_origin_state.dart';
import 'package:flutter_project_august/repo/origin_repo.dart';

class CreateOriginBloc extends Bloc<CreateOriginEvent, CreateOriginState> {
  final OriginRepo originRepo;

  CreateOriginBloc({required this.originRepo}) : super(CreateOriginInitial()) {
    on<CreateOriginRequested>(_onCreateOriginRequested);
  }

  Future<void> _onCreateOriginRequested(
      CreateOriginRequested event, Emitter<CreateOriginState> emit) async {
    emit(CreateOriginLoading());
    try {
      final success = await originRepo.createOrigin(
        name: event.name,
      );
      if (success) {
        emit(CreateOriginSuccess());
      } else {
        emit(const CreateOriginFailure(error: 'Failed to create origin.'));
      }
    } catch (e) {
      emit(CreateOriginFailure(error: e.toString()));
    }
  }
}
