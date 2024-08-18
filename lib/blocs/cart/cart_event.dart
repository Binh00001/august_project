// cart_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_project_august/models/product_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddProductToCart extends CartEvent {
  final Product product;
  final num quantity;

  const AddProductToCart({required this.product, required this.quantity});

  @override
  List<Object?> get props => [product, quantity];
}

class RemoveProductFromCart extends CartEvent {
  final Product product;

  const RemoveProductFromCart({required this.product});

  @override
  List<Object?> get props => [product];
}

class UpdateProductQuantity extends CartEvent {
  final Product product;
  final num quantity;

  const UpdateProductQuantity({required this.product, required this.quantity});

  @override
  List<Object?> get props => [product, quantity];
}

class ClearCart extends CartEvent {}
