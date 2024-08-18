// cart_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:flutter_project_august/models/product_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<AddProductToCart>(_onAddProductToCart);
    on<RemoveProductFromCart>(_onRemoveProductFromCart);
    on<UpdateProductQuantity>(_onUpdateProductQuantity);
    on<ClearCart>(_onClearCart);
  }

  void _onAddProductToCart(AddProductToCart event, Emitter<CartState> emit) {
    final updatedProducts = Map<Product, num>.from(state.products);
    if (updatedProducts.containsKey(event.product)) {
      updatedProducts[event.product] =
          updatedProducts[event.product]! + event.quantity;
    } else {
      updatedProducts[event.product] = event.quantity;
    }
    emit(CartUpdated(products: updatedProducts));
  }

  void _onRemoveProductFromCart(
      RemoveProductFromCart event, Emitter<CartState> emit) {
    final updatedProducts = Map<Product, num>.from(state.products);
    updatedProducts.remove(event.product);
    emit(CartUpdated(products: updatedProducts));
  }

  void _onUpdateProductQuantity(
      UpdateProductQuantity event, Emitter<CartState> emit) {
    final updatedProducts = Map<Product, num>.from(state.products);
    if (updatedProducts.containsKey(event.product)) {
      updatedProducts[event.product] = event.quantity;
      emit(CartUpdated(products: updatedProducts));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(CartUpdated(products: {}));
  }
}
