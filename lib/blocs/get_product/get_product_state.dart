import 'package:equatable/equatable.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<dynamic> products;
  final int totalItems;
  final int totalPages;

  const ProductLoaded({
    required this.products,
    required this.totalItems,
    required this.totalPages,
  });

  @override
  List<Object> get props => [products, totalItems, totalPages];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}
