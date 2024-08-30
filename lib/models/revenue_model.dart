class Revenue {
  String month;
  int revenue;

  Revenue({
    required this.month,
    required this.revenue,
  });

  factory Revenue.fromJson(Map<String, dynamic> json) {
    return Revenue(
      month: json['month'],
      revenue: json['revenue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'revenue': revenue,
    };
  }
}
