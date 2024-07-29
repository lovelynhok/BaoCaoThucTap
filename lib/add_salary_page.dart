import 'package:flutter/material.dart';
import 'models/salary.dart';
import 'providers/salary_provider.dart';

class AddSalaryPage extends StatefulWidget {
  final VoidCallback onAdd; // Tham số onAdd kiểu VoidCallback

  AddSalaryPage({required this.onAdd});

  @override
  _AddSalaryPageState createState() => _AddSalaryPageState();
}

class _AddSalaryPageState extends State<AddSalaryPage> {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  final _salaryController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void dispose() {
    _employeeIdController.dispose();
    _salaryController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm lương'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _employeeIdController,
                decoration: InputDecoration(labelText: 'Employee ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập ID nhân viên';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _salaryController,
                decoration: InputDecoration(labelText: 'Mức lương'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mức lương';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Vui lòng nhập số hợp lệ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Ngày (YYYY-MM-DD)'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập ngày';
                  }
                  // Validation for date format (e.g., YYYY-MM-DD) can be added here
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final salary = Salary(
                      id: 0, // ID will be assigned by the server
                      employeeId: int.parse(_employeeIdController.text),
                      salary: double.parse(_salaryController.text),
                      date: _dateController.text,
                      createdAt: DateTime.now().toIso8601String(),
                      updatedAt: DateTime.now().toIso8601String(),
                    );

                    ApiService().addSalary(salary).then((_) {
                      widget.onAdd(); // Gọi callback khi thêm lương thành công
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lương đã được thêm')),
                      );
                      Navigator.pop(context);
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi: ${error.toString()}')),
                      );
                    });
                  }
                },
                child: Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
