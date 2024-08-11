import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CreateCategoryEvent extends Equatable {
  const CreateCategoryEvent();

  @override
  List<Object> get props => [];
}

class CreateCategoryRequested extends CreateCategoryEvent {
  final String name;

  const CreateCategoryRequested({
    required this.name,
  });

  @override
  List<Object> get props => [name];
}
