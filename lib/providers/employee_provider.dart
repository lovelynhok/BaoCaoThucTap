import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/employee_model.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.6:3000'; // Thay bằng địa chỉ API của bạn

  // -------------------------- Admin API Methods --------------------------

  //-------------------------- Employee API Methods --------------------------

  Future<List<Employee>> fetchEmployees() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/employee'));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((e) => Employee.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching employees: $e');
    }
  }

  Future<void> addEmployee(Employee employee, File? avatar) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/employee'),
      );

      request.fields['name'] = employee.name;
      request.fields['position'] = employee.position;
      request.fields['salary'] = employee.salary.toString();
      request.fields['hired_date'] = employee.hiredDate.toIso8601String();
      request.fields['address'] = employee.address;
      request.fields['phone_number'] = employee.phoneNumber;
      request.fields['email'] = employee.email;
      request.fields['is_active'] = employee.isActive.toString();

      if (avatar != null) {
        request.files.add(
          http.MultipartFile(
            'avatar',
            avatar.readAsBytes().asStream(),
            avatar.lengthSync(),
            filename: avatar.path.split('/').last,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      final response = await request.send();

      if (response.statusCode != 201) {
        throw Exception('Failed to add employee');
      }
    } catch (e) {
      throw Exception('Error occurred while adding employee: $e');
    }
  }

  Future<void> updateEmployee(Employee employee, File? avatar) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/employee/${employee.id}'),
      );

      request.fields['name'] = employee.name;
      request.fields['position'] = employee.position;
      request.fields['salary'] = employee.salary.toString();
      request.fields['hired_date'] = employee.hiredDate.toIso8601String();
      request.fields['address'] = employee.address;
      request.fields['phone_number'] = employee.phoneNumber;
      request.fields['email'] = employee.email;
      request.fields['is_active'] = employee.isActive.toString();

      if (avatar != null) {
        request.files.add(
          http.MultipartFile(
            'avatar',
            avatar.readAsBytes().asStream(),
            avatar.lengthSync(),
            filename: avatar.path.split('/').last,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      final response = await request.send();

      if (response.statusCode != 200) {
        throw Exception('Failed to update employee');
      }
    } catch (e) {
      throw Exception('Error occurred while updating employee: $e');
    }
  }

  Future<void> deleteEmployee(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/employee/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete employee');
      }
    } catch (e) {
      throw Exception('Error occurred while deleting employee: $e');
    }
  }
}
