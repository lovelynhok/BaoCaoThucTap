import 'package:flutter/material.dart';
import 'models/salary.dart';
import 'providers/salary_provider.dart';
import 'detail_salary_page.dart';
import 'add_salary_page.dart';

class SalaryListPage extends StatefulWidget {
  @override
  _SalaryListPageState createState() => _SalaryListPageState();
}

class _SalaryListPageState extends State<SalaryListPage> {
  late Future<List<Salary>> futureSalaries;

  @override
  void initState() {
    super.initState();
    _loadSalaries();
  }

  void _loadSalaries() {
    setState(() {
      futureSalaries = ApiService().getSalaries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách lương'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSalaryPage(onAdd: () {
                    // Sau khi thêm xong, tải lại danh sách
                    _loadSalaries();
                  }),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Salary>>(
        future: futureSalaries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Danh sách lương trống.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final salary = snapshot.data![index];
                return ListTile(
                  title: Text('Lương: \$${salary.salary.toStringAsFixed(2)}'),
                  subtitle: Text('Ngày: ${salary.date}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SalaryDetailPage(salaryId: salary.id),
                      ),
                    ).then((_) {
                      // Sau khi quay lại từ trang chi tiết, tải lại danh sách
                      _loadSalaries();
                    });
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
