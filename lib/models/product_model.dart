class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Origin {
  final String id;
  final String name;

  Origin({
    required this.id,
    required this.name,
  });

  factory Origin.fromJson(Map<String, dynamic> json) {
    return Origin(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Product {
  final String id;
  final String name;
  final String? imageUrl;
  final String price;
  final DateTime createdAt;
  final Category category;
  final String unit;
  Product(
      {required this.id,
      required this.name,
      this.imageUrl,
      required this.price,
      required this.createdAt,
      required this.category,
      required this.unit});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      price: json['price'],
      createdAt: DateTime.parse(json['created_at']),
      category: Category.fromJson(json['category']),
      unit: json['unit'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'price': price,
      'created_at': createdAt.toIso8601String(),
      'category': category.toJson(),
      'unit': unit
    };
  }
}
