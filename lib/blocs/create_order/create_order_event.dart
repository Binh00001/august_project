// order_event.dart
import 'package:equatable/equatable.dart';

abstract class CreateOrderEvent extends Equatable {
  const CreateOrderEvent();

  @override
  List<Object?> get props => [];
}

class CreateOrder extends CreateOrderEvent {
  final List<Map<String, dynamic>> products;
  final num totalAmount;

  const CreateOrder({required this.products, required this.totalAmount});

  @override
  List<Object?> get props => [products, totalAmount];
}
