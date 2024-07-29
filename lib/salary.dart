import 'package:flutter/material.dart';
class salary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lương Thưởng',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      body: salaryr(),
    );

  }
}



class salaryr extends StatelessWidget {
  final List<Employee> employees = [
    Employee(name: 'John Doe', position: 'Developer', salary: 5000, bonus: 1000),
    Employee(name: 'Jane Smith', position: 'Designer', salary: 4500, bonus: 800),
    Employee(name: 'Mike Johnson', position: 'Manager', salary: 6000, bonus: 1200),
    Employee(name: 'Emily Brown', position: 'Tester', salary: 4000, bonus: 600),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Salary Management'),
          backgroundColor: Colors.blueAccent,
        ),
        body: ListView.builder(
          itemCount: employees.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text((index + 1).toString()),
                ),
                title: Text(employees[index].name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Position: ${employees[index].position}'),
                    Text('Salary: \$${employees[index].salary.toString()}'),
                    Text('Bonus: \$${employees[index].bonus.toString()}'),
                  ],
                ),
                onTap: () {
                  _showSalaryDetail(context, employees[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSalaryDetail(BuildContext context, Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Salary Detail'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: ${employee.name}'),
            SizedBox(height: 8),
            Text('Position: ${employee.position}'),
            Text('Salary: \$${employee.salary.toString()}'),
            Text('Bonus: \$${employee.bonus.toString()}'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

class Employee {
  final String name;
  final String position;
  final int salary;
  final int bonus;

  Employee({required this.name, required this.position, required this.salary, required this.bonus});
}