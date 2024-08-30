abstract class UpdateProductEvent {}

class UpdateProductButtonPressed extends UpdateProductEvent {
  final String name;
  final String price;
  final String imageFile;

  UpdateProductButtonPressed({
    required this.name,
    required this.price,
    required this.imageFile,
  });
}
