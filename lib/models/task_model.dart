import 'package:flutter_project_august/models/staff_model.dart';

class Task {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  final Staff? staff; // Nullable, as staff can be null

  Task({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    this.staff,
  });

  // Factory constructor for creating a new `Task` instance from a map
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      quantity: (json['quantity'] is int)
          ? (json['quantity'] as int).toDouble() // Convert int to double
          : json['quantity']
              as double, // Directly use if it's already doubleEnsure quantity is treated as double
      unit: json['unit'],
      staff: json['staff'] != null ? Staff.fromJson(json['staff']) : null,
    );
  }

  // Method for converting a `Task` instance into a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'staff': staff?.toJson(), // Convert Staff to JSON if it's not null
    };
  }
}
