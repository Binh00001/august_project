class Staff {
  final String id;
  final String username;
  final String name;
  final String role;
  final String? deletedAt;

  Staff({
    required this.id,
    required this.username,
    required this.name,
    required this.role,
    this.deletedAt,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      role: json['role'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'role': role,
      'deleted_at': deletedAt,
    };
  }
}
