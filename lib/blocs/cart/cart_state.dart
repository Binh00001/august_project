// cart_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_project_august/models/product_model.dart';

class CartState extends Equatable {
  final Map<Product, num> products;

  const CartState({this.products = const {}});

  CartState copyWith({Map<Product, num>? products}) {
    return CartState(
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [products];
}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  const CartUpdated({required Map<Product, num> products})
      : super(products: products);
}
