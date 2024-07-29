import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:untitled1/models/salary.dart';

class ApiService {
  final String apiUrl = "http://192.168.1.6:3000/salary";

  // Lấy danh sách tất cả các mức lương
  Future<List<Salary>> getSalaries() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      Iterable jsonResponse = json.decode(response.body);
      return List<Salary>.from(jsonResponse.map((model) => Salary.fromJson(model)));
    } else {
      throw Exception('Failed to load salaries');
    }
  }

  // Lấy mức lương theo ID
  Future<Salary> getSalary(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));
    if (response.statusCode == 200) {
      return Salary.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load salary');
    }
  }

  // Thêm mức lương mới
  Future<Salary> addSalary(Salary salary) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(salary.toJson()),
    );
    if (response.statusCode == 201) {
      return Salary.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add salary');
    }
  }

  // Cập nhật mức lương theo ID
  Future<Salary> updateSalary(int id, Salary salary) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(salary.toJson()),
    );
    if (response.statusCode == 200) {
      return Salary.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update salary');
    }
  }

  // Xóa mức lương theo ID
  Future<void> deleteSalary(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete salary');
    }
  }
}
