class SchoolFields {
  static final String tableSchools = 'schools';
  static final String id = 'id';
  static final String name = 'name';
  static final String address = 'address';
  static final String phoneNumber = 'phone_number';
}

class School {
  final String id;
  final String name;
  final String? address;
  final String? phoneNumber;

  School(
      {required this.id, required this.name, this.address, this.phoneNumber});

  // Factory constructor to create a School instance from a map (usually from JSON data)
  factory School.fromJson(Map<String, String> json) {
    return School(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      address: json['address'] ?? "",
      phoneNumber: json['contact_number'] ?? "",
    );
  }

  // Method to convert the School instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'contact_number': phoneNumber,
    };
  }
}
