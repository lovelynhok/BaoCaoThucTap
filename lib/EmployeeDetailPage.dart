import 'dart:io';
import 'package:flutter/material.dart';
import 'models/employee_model.dart';
import 'EmployeeFormPage.dart';
import 'providers/employee_provider.dart';

class EmployeeDetailPage extends StatelessWidget {
  final Employee employee;
  final ApiService apiService;

  EmployeeDetailPage({required this.employee, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết nhân viên'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployeeFormPage(
                    apiService: apiService,
                    employee: employee,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailCard('Tên', employee.name, Icons.person),
            _buildDetailCard('Vị Trí', employee.position, Icons.work),
            _buildDetailCard('Lương', '\$${employee.salary.toStringAsFixed(2)}', Icons.money),
            _buildDetailCard('Địa chỉ', employee.address, Icons.location_on),
            _buildDetailCard('Số điện thoại', employee.phoneNumber, Icons.phone),
            _buildDetailCard('Email', employee.email, Icons.email),
            _buildDetailCard(
              'Ngày vào làm',
              employee.hiredDate != null
                  ? employee.hiredDate.toLocal().toString().split(' ')[0]
                  : 'N/A',
              Icons.calendar_today,
            ),
            _buildDetailCard('Trạng thái', employee.isActive ? 'Hoạt Động' : 'Không Hoạt Động', Icons.check_circle),
            if (employee.avatarPath != null) ...[
              SizedBox(height: 16.0),
              Center(
                child: ClipOval(
                  child: Image.file(
                    File(employee.avatarPath!),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        subtitle: Text(
          value,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
