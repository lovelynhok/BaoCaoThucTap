import 'package:flutter/material.dart';
import 'models/salary.dart';
import 'providers/salary_provider.dart';

class SalaryDetailPage extends StatelessWidget {
  final int salaryId;

  SalaryDetailPage({required this.salaryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết lương'),
      ),
      body: FutureBuilder<Salary>(
        future: ApiService().getSalary(salaryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Lương không tìm thấy.'));
          } else {
            final salary = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  ListTile(
                    title: Text('ID Nhân viên'),
                    subtitle: Text('${salary.employeeId}'),
                  ),
                  ListTile(
                    title: Text('Mức lương'),
                    subtitle: Text('\$${salary.salary.toStringAsFixed(2)}'),
                  ),
                  ListTile(
                    title: Text('Ngày'),
                    subtitle: Text(salary.date),
                  ),
                  ListTile(
                    title: Text('Ngày tạo'),
                    subtitle: Text(salary.createdAt),
                  ),
                  ListTile(
                    title: Text('Ngày cập nhật'),
                    subtitle: Text(salary.updatedAt),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
