import 'dart:io';
import 'package:flutter/material.dart';
import 'providers/employee_provider.dart';
import 'models/employee_model.dart';
import 'EmployeeFormPage.dart';
import 'EmployeeDetailPage.dart';

class EmployeeListPage extends StatefulWidget {
  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  late Future<List<Employee>> futureEmployees;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _refreshEmployees();
  }

  Future<void> _refreshEmployees() async {
    setState(() {
      futureEmployees = apiService.fetchEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách nhân viên'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployeeFormPage(apiService: apiService)),
              ).then((_) => _refreshEmployees());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Employee>>(
        future: futureEmployees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không tìm thấy nhân viên'));
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 8.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final employee = snapshot.data![index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    leading: employee.avatarPath != null
                        ? CircleAvatar(
                      backgroundImage: FileImage(File(employee.avatarPath!)),
                      backgroundColor: Colors.grey[200],
                    )
                        : CircleAvatar(
                      child: Icon(Icons.person, size: 40),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    title: Text(
                      employee.name,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    subtitle: Text(employee.position),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmployeeDetailPage(
                            employee: employee,
                            apiService: apiService,
                          ),
                        ),
                      );
                    },
                    trailing: SizedBox(
                      width: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.teal),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmployeeFormPage(
                                    apiService: apiService,
                                    employee: employee,
                                  ),
                                ),
                              ).then((_) => _refreshEmployees());
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirmDelete = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Xác nhận xóa'),
                                  content: Text('Bạn có chắc chắn muốn xóa nhân viên này?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Hủy'),
                                      onPressed: () => Navigator.of(context).pop(false),
                                    ),
                                    TextButton(
                                      child: Text('Xóa'),
                                      onPressed: () => Navigator.of(context).pop(true),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmDelete) {
                                try {
                                  await apiService.deleteEmployee(employee.id);
                                  _refreshEmployees();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Xóa nhân viên thất bại')),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
