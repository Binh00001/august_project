import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CreateOriginEvent extends Equatable {
  const CreateOriginEvent();

  @override
  List<Object> get props => [];
}

class CreateOriginRequested extends CreateOriginEvent {
  final String name;

  const CreateOriginRequested({
    required this.name,
  });

  @override
  List<Object> get props => [name];
}
