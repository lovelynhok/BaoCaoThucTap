
import 'package:flutter/material.dart';
class Manager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hiệu Suất',
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
      body: PerformanceScreen(),
    );

  }
}



class PerformanceScreen extends StatelessWidget {
  final List<Employee> employees = [
    Employee(
      name: 'John Doe',
      image: 'https://via.placeholder.com/150',
      revenue: 25000,
      sales: 150,
      rating: 4.5,
      details:
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed aliquet urna ut nunc rutrum, nec dapibus magna mollis.',
    ),
    Employee(
      name: 'Jane Smith',
      image: 'https://via.placeholder.com/150',
      revenue: 35000,
      sales: 120,
      rating: 4.2,
      details:
      'Vestibulum feugiat, urna id tempus interdum, est ex mollis felis, nec varius nisl velit nec tortor.',
    ),
    Employee(
      name: 'Michael Johnson',
      image: 'https://via.placeholder.com/150',
      revenue: 18000,
      sales: 90,
      rating: 3.8,
      details:
      'Integer maximus quam in enim tincidunt, et iaculis nunc aliquam. In vestibulum auctor libero.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView.builder(
          itemCount: employees.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _navigateToEmployeeDetail(context, employees[index]);
              },
              child: Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(employees[index].image),
                  ),
                  title: Text(employees[index].name),
                  subtitle: Text('Revenue: \$${employees[index].revenue}'),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToEmployeeDetail(BuildContext context, Employee employee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeDetailScreen(employee: employee),
      ),
    );
  }
}

class Employee {
  final String name;
  final String image;
  final int revenue;
  final int sales;
  final double rating;
  final String details;

  Employee({
    required this.name,
    required this.image,
    required this.revenue,
    required this.sales,
    required this.rating,
    required this.details,
  });
}

class EmployeeDetailScreen extends StatelessWidget {
  final Employee employee;

  EmployeeDetailScreen({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(employee.image),
                  ),
                  SizedBox(height: 16),
                  Text(
                    employee.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            _buildCard(
              title: 'Revenue',
              subtitle: 'Total revenue generated',
              value: '\$${employee.revenue.toString()}',
              icon: Icons.attach_money,
              color: Colors.green,
            ),
            _buildCard(
              title: 'Sales',
              subtitle: 'Number of sales made',
              value: employee.sales.toString(),
              icon: Icons.shopping_cart,
              color: Colors.orange,
            ),
            _buildCard(
              title: 'Rating',
              subtitle: 'Average rating',
              value: employee.rating.toString(),
              icon: Icons.star,
              color: Colors.blue,
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    employee.details,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}