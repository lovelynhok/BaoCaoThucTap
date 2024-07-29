class Timesheet {
  final int id;
  final String employeeId;
  final DateTime date; // Sử dụng DateTime
  final int hoursWorked;
  final String name;
  final String position;
  final DateTime createdAt; // Sử dụng DateTime
  final DateTime updatedAt; // Sử dụng DateTime

  Timesheet({
    required this.id,
    required this.employeeId,
    required this.date, // Chuyển đổi kiểu
    required this.hoursWorked,
    required this.name,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Timesheet.fromJson(Map<String, dynamic> json) {
    return Timesheet(
      id: int.tryParse(json['id'].toString()) ?? 0,
      employeeId: json['employee_id'] as String? ?? '',
      date: DateTime.parse(json['date'] as String? ?? DateTime.now().toIso8601String()), // Chuyển đổi từ String thành DateTime
      hoursWorked: int.tryParse(json['hours_worked'].toString()) ?? 0,
      name: json['employee_name'] as String? ?? '',
      position: json['employee_position'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()), // Chuyển đổi từ String thành DateTime
      updatedAt: DateTime.parse(json['updated_at'] as String? ?? DateTime.now().toIso8601String()), // Chuyển đổi từ String thành DateTime
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'date': date.toIso8601String(), // Chuyển đổi từ DateTime thành String
      'hours_worked': hoursWorked,
      'employee_name': name,
      'employee_position': position,
      'created_at': createdAt.toIso8601String(), // Chuyển đổi từ DateTime thành String
      'updated_at': updatedAt.toIso8601String(), // Chuyển đổi từ DateTime thành String
    };
  }
}
