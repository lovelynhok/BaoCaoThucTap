import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled1/models/timesheet.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.6:3000';

  Future<List<Timesheet>> fetchTimesheets() async {
    final response = await http.get(Uri.parse('$baseUrl/timesheet'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Timesheet.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load timesheets');
    }
  }

  Future<Timesheet> fetchTimesheet(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/timesheet/$id'));

    if (response.statusCode == 200) {
      return Timesheet.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load timesheet');
    }
  }

  Future<void> createTimesheet(Timesheet timesheet) async {
    final response = await http.post(
      Uri.parse('$baseUrl/timesheet'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(timesheet.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create timesheet');
    }
  }

  Future<void> updateTimesheet(Timesheet timesheet) async {
    final response = await http.put(
      Uri.parse('$baseUrl/timesheet/${timesheet.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(timesheet.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update timesheet');
    }
  }

  Future<void> deleteTimesheet(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/timesheet/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete timesheet');
    }
  }
}
