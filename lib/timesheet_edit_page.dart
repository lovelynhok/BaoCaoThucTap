import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thêm package intl
import 'providers/timesheet_provider.dart';
import 'models/timesheet.dart';

class TimesheetEditPage extends StatefulWidget {
  final Timesheet timesheet;

  TimesheetEditPage({required this.timesheet});

  @override
  _TimesheetEditPageState createState() => _TimesheetEditPageState();
}

class _TimesheetEditPageState extends State<TimesheetEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _employeeIdController;
  late TextEditingController _dateController;
  late TextEditingController _hoursWorkedController;
  DateTime _selectedDate = DateTime.now(); // Thay đổi để sử dụng DateTime

  @override
  void initState() {
    super.initState();
    _employeeIdController = TextEditingController(text: widget.timesheet.employeeId);
    _dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(widget.timesheet.date)); // Chuyển đổi DateTime thành String
    _hoursWorkedController = TextEditingController(text: widget.timesheet.hoursWorked.toString());
    _selectedDate = widget.timesheet.date; // Đặt giá trị mặc định cho _selectedDate
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _dateController.dispose();
    _hoursWorkedController.dispose();
    super.dispose();
  }

  Future<void> _saveTimesheet() async {
    if (_formKey.currentState!.validate()) {
      final employeeId = _employeeIdController.text;
      final date = _selectedDate; // Sử dụng DateTime thay vì String
      final hoursWorked = int.tryParse(_hoursWorkedController.text) ?? 0;

      final timesheet = Timesheet(
        id: widget.timesheet.id,
        employeeId: employeeId,
        date: date, // Sử dụng DateTime
        hoursWorked: hoursWorked,
        name: widget.timesheet.name,
        position: widget.timesheet.position,
        createdAt: widget.timesheet.createdAt,
        updatedAt: DateTime.now(), // Cập nhật ngày sửa
      );

      try {
        if (widget.timesheet.id == 0) {
          await ApiService().createTimesheet(timesheet);
        } else {
          await ApiService().updateTimesheet(timesheet);
        }
        Navigator.pop(context, true);
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate); // Cập nhật giá trị của TextEditingController
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Timesheet'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _employeeIdController,
                decoration: InputDecoration(labelText: 'Employee ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter employee ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              TextFormField(
                controller: _hoursWorkedController,
                decoration: InputDecoration(labelText: 'Hours Worked'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter hours worked';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTimesheet,
                child: Text('Save'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
