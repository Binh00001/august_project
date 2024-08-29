class OrderItem {
  final String quantity;
  final String price;
  final String productName;
  final String productId;
  final String productUnit;

  OrderItem(
      {required this.quantity,
      required this.price,
      required this.productName,
      required this.productId,
      required this.productUnit});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    // Kiểm tra product có null không và gán giá trị mặc định nếu cần
    final product = json['product'];
    final productName =
        product != null ? product['name'] ?? "" : "Sản phẩm đã bị xoá";
    final productId =
        product != null ? product['id'] ?? "" : "Sản phẩm đã bị xoá";
    final productUnit =
        product != null ? product['unit'] ?? "" : "Sản phẩm đã bị xoá";

    return OrderItem(
      quantity: json['quantity'] ?? "",
      price: json['price'] ?? "",
      productName: productName,
      productId: productId,
      productUnit: productUnit,
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
      id: json['id'] ?? "",
      userName: json['user']['name'] ?? "",
      userId: json['user']['id'] ?? "",
      orderItems: (json['orderItems'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      schoolId: json['school']['id'] ?? "",
      schoolName: json['school']['name'] ?? "",
      totalAmount: json['total_amount'] ?? "",
      status: json['status'] ?? "",
      payStatus: json['pay_status'] ?? "",
      createdAt: json['created_at'] ?? "",
    );
  }
}
