import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CreateProductEvent extends Equatable {
  const CreateProductEvent();

  @override
  List<Object> get props => [];
}

class CreateProductRequested extends CreateProductEvent {
  final String name;
  final String unit;
  final String price;
  final String categoryId;
  final String originId;
  final XFile? imageFile;

  const CreateProductRequested({
    required this.name,
    required this.unit,
    required this.price,
    required this.categoryId,
    required this.originId,
    this.imageFile,
  });

  @override
  List<Object> get props =>
      [name, unit, price, categoryId, originId, imageFile!];
}
