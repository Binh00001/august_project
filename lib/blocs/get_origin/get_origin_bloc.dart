import 'package:bloc/bloc.dart';
import 'package:flutter_project_august/blocs/get_origin/get_origin_event.dart';
import 'package:flutter_project_august/blocs/get_origin/get_origin_state.dart';
import 'package:flutter_project_august/repo/origin_repo.dart';

class OriginBloc extends Bloc<OriginEvent, OriginState> {
  final OriginRepo originRepo;

  OriginBloc({required this.originRepo}) : super(OriginInitial()) {
    on<FetchOrigins>(_onFetchOrigins);
  }

  Future<void> _onFetchOrigins(
      FetchOrigins event, Emitter<OriginState> emit) async {
    emit(OriginLoading());
    try {
      final origins = await originRepo.getOrigins(
          1, 100); // Assumes a getOrigins method in the repo
      emit(OriginLoaded(origins: origins));
    } catch (e) {
      emit(OriginError(message: e.toString()));
    }
  }
}
