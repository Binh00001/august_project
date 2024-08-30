// delete_product_event.dart

abstract class DeleteProductEvent {}

class DeleteProduct extends DeleteProductEvent {
  final String productId;

  DeleteProduct(this.productId);
}
