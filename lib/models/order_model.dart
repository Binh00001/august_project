import 'package:flutter_project_august/models/product_model.dart';

class OrderItem {
  final int quantity;
  final String price;
  final Product product;

  OrderItem(
      {required this.quantity, required this.price, required this.product});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      quantity: json['quantity'],
      price: json['price'],
      product: Product.fromJson(json['product']),
    );
  }
}

class Order {
  final String id;
  final String userName;
  final String userId;
  final List<OrderItem> orderItems;
  final String schoolId;
  final String schoolName;
  final String totalAmount;
  final String status;
  final String payStatus;
  final String createdAt;

  Order({
    required this.id,
    required this.userName,
    required this.userId,
    required this.orderItems,
    required this.schoolId,
    required this.schoolName,
    required this.totalAmount,
    required this.status,
    required this.payStatus,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userName: json['user']['name'],
      userId: json['user']['id'],
      orderItems: (json['orderItems'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      schoolId: json['school']['id'],
      schoolName: json['school']['name'],
      totalAmount: json['totalAmount'],
      status: json['status'],
      payStatus: json['payStatus'],
      createdAt: json['createdAt'],
    );
  }
}
