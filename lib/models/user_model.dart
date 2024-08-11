class User {
  final String id;
  final String username;
  final String name;
  final String role;
  final String? deletedAt;
  final String schoolId;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.role,
    this.deletedAt,
    required this.schoolId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      role: json['role'],
      deletedAt: json['deleted_at'],
      schoolId: json['school_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'role': role,
      'deleted_at': deletedAt,
      'school_id': schoolId,
    };
  }
}
