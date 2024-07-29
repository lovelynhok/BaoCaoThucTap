import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class ChamCong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chấm công',
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
      body: AttendanceApp(),
    );

  }
}
class AttendanceApp extends StatelessWidget {
  late DateTime selectedDate = DateTime.now();

  final List<AttendanceRecord> attendanceRecords = [
    AttendanceRecord(date: '2024-07-01', status: 'Present', reason: ''),
    AttendanceRecord(date: '2024-07-02', status: 'Absent', reason: 'Sick leave'),
    AttendanceRecord(date: '2024-07-03', status: 'Present', reason: ''),
    AttendanceRecord(date: '2024-07-04', status: 'Present', reason: ''),
    AttendanceRecord(date: '2024-07-05', status: 'Late', reason: 'Traffic'),
    AttendanceRecord(date: '2024-07-06', status: 'Present', reason: ''),
    AttendanceRecord(date: '2024-07-07', status: 'Present', reason: ''),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Attendance'),
          backgroundColor: Colors.teal,
          actions: [
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2025),
                );
                if (picked != null && picked != selectedDate) {
                  selectedDate = picked;
                  // TODO: Load attendance records for selected date
                  // You can update the UI or load data accordingly here
                }
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.teal,
              child: Center(
                child: Text(
                  'July 2024',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: attendanceRecords.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(attendanceRecords[index].status),
                      child: _getStatusIcon(attendanceRecords[index].status),
                    ),
                    title: Text(attendanceRecords[index].date),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Status: ${attendanceRecords[index].status}'),
                        if (attendanceRecords[index].reason.isNotEmpty)
                          Text('Reason: ${attendanceRecords[index].reason}'),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      _showAttendanceDetail(context, attendanceRecords[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Present':
        return Colors.green;
      case 'Absent':
        return Colors.red;
      case 'Late':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _getStatusIcon(String status) {
    switch (status) {
      case 'Present':
        return Icon(Icons.check, color: Colors.white);
      case 'Absent':
        return Icon(Icons.close, color: Colors.white);
      case 'Late':
        return Icon(Icons.access_time, color: Colors.white);
      default:
        return Icon(Icons.help_outline, color: Colors.white);
    }
  }

  void _showAttendanceDetail(BuildContext context, AttendanceRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Attendance Detail'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Date: ${record.date}'),
            SizedBox(height: 8),
            Text('Status: ${record.status}'),
            if (record.reason.isNotEmpty) ...[
              SizedBox(height: 8),
              Text('Reason: ${record.reason}'),
            ]
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

class AttendanceRecord {
  final String date;
  final String status;
  final String reason;

  AttendanceRecord({required this.date, required this.status, required this.reason});
}