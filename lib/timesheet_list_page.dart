import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thêm package intl
import 'providers/timesheet_provider.dart';
import 'models/timesheet.dart';
import 'timesheet_detail_page.dart';
import 'timesheet_edit_page.dart';

class TimesheetListPage extends StatefulWidget {
  @override
  _TimesheetListPageState createState() => _TimesheetListPageState();
}

class _TimesheetListPageState extends State<TimesheetListPage> {
  late Future<List<Timesheet>> futureTimesheets;

  @override
  void initState() {
    super.initState();
    futureTimesheets = ApiService().fetchTimesheets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timesheet List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Timesheet>>(
        future: futureTimesheets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No timesheets found.'));
          }

          final timesheets = snapshot.data!;

          return ListView.builder(
            itemCount: timesheets.length,
            itemBuilder: (context, index) {
              final timesheet = timesheets[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 5,
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  title: Text(
                    timesheet.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${DateFormat('yyyy-MM-dd').format(timesheet.date)} - ${timesheet.hoursWorked} hours',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimesheetDetailPage(id: timesheet.id),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TimesheetEditPage(timesheet: timesheet),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TimesheetEditPage(timesheet: Timesheet(
                id: 0,
                employeeId: '',
                date: DateTime.now(), // Sử dụng DateTime cho trường date
                hoursWorked: 0,
                name: '',
                position: '',
                createdAt: DateTime.now(), // Sử dụng DateTime cho trường createdAt
                updatedAt: DateTime.now(), // Sử dụng DateTime cho trường updatedAt
              )),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
