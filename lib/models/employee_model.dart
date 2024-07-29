import 'dart:convert';

class Employee {
  final int id;
  final String name;
  final String position;
  final double salary;
  final DateTime hiredDate;
  final String address;
  final String phoneNumber;
  final String email;
  final bool isActive;
  final String? avatarPath;

  Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.salary,
    required this.hiredDate,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.isActive,
    this.avatarPath,
  });

  // Phương thức để tạo đối tượng Employee từ JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      position: json['position'] ?? '',
      salary: (json['salary'] is String) ? double.parse(json['salary']) : json['salary'].toDouble(),
      hiredDate: DateTime.parse(json['hired_date'] ?? DateTime.now().toIso8601String()),
      address: json['address'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      isActive: json['is_active'] ?? true,
      avatarPath: json['avatar_path'],
    );
  }

  // Phương thức để chuyển đối tượng Employee thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'salary': salary,
      'hired_date': hiredDate.toIso8601String(),
      'address': address,
      'phone_number': phoneNumber,
      'email': email,
      'is_active': isActive,
      'avatar_path': avatarPath,
    };
  }
}
