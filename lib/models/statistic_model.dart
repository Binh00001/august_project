// product_statistic.dart

class ProductStatistic {
  final String id;
  final String name;
  final double price;
  final double totalQuantity;
  final double totalPrice;

  ProductStatistic({
    required this.id,
    required this.name,
    required this.price,
    required this.totalQuantity,
    required this.totalPrice,
  });

  factory ProductStatistic.fromJson(Map<String, dynamic> json) {
    return ProductStatistic(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      price: double.parse(json['price']),
      totalQuantity: double.parse(json['totalQuantity'].toString()),
      totalPrice: double.parse(json['totalPrice'].toString()),
    );
  }
}

class StatisticalData {
  final List<ProductStatistic> products;

  StatisticalData({required this.products});

  factory StatisticalData.fromJson(Map<String, dynamic> json) {
    var list = json['products'] as List;
    List<ProductStatistic> productList =
        list.map((i) => ProductStatistic.fromJson(i)).toList();
    return StatisticalData(products: productList);
  }
}
