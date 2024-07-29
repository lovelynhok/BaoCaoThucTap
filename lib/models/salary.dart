class Salary {
  final int id;
  final int employeeId;
  final double salary;
  final String date;
  final String createdAt;
  final String updatedAt;

  Salary({
    required this.id,
    required this.employeeId,
    required this.salary,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Salary.fromJson(Map<String, dynamic> json) {
    return Salary(
      id: json['id'] ?? 0, // Cung cấp giá trị mặc định nếu null
      employeeId: json['employee_id'] ?? 0, // Cung cấp giá trị mặc định nếu null
      salary: _parseDouble(json['salary']), // Sử dụng phương thức riêng để chuyển đổi
      date: json['date'] ?? '', // Cung cấp giá trị mặc định nếu null
      createdAt: json['created_at'] ?? '', // Cung cấp giá trị mặc định nếu null
      updatedAt: json['updated_at'] ?? '', // Cung cấp giá trị mặc định nếu null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'salary': salary,
      'date': date,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Phương thức riêng để chuyển đổi giá trị thành double
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      // Kiểm tra và chuyển đổi từ String thành double
      final parsed = double.tryParse(value);
      return parsed ?? 0.0;
    }
    return 0.0;
  }
}
