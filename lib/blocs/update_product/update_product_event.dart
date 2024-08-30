import 'package:image_picker/image_picker.dart';

abstract class UpdateProductEvent {}

class UpdateProductButtonPressed extends UpdateProductEvent {
  final String? name;
  final String? price;
  final String productId;
  final XFile? imageFile;

  UpdateProductButtonPressed({
    required this.name,
    required this.price,
    required this.productId,
    required this.imageFile,
  });
}
