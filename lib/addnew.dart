/*import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class AddList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thêm mới nhân viên',
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
      body: EmployeeApp(),
    );

  }
}
class Employee {
  final String name;
  final String address;
  final String email;
  final String department;
  final String accountType;
  final String gender;
  final String position;
  File? imageFile;

  Employee({
    required this.name,
    required this.address,
    required this.email,
    required this.department,
    required this.accountType,
    required this.gender,
    required this.position,
    this.imageFile,
  });
}

class EmployeeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddEmployeeScreen(),
    );
  }
}

class AddEmployeeScreen extends StatefulWidget {
  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  String selectedDepartment = 'IT'; // Phòng ban mặc định
  String selectedAccountType = 'Normal'; // Loại tài khoản mặc định
  String selectedGender = 'Male'; // Giới tính mặc định
  String selectedPosition = 'Software Engineer'; // Vị trí mặc định

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  List<String> departments = ['IT', 'HR', 'Finance', 'Marketing'];
  List<String> accountTypes = ['Normal', 'Admin', 'Manager'];
  List<String> genders = ['Male', 'Female'];
  List<String> positions = [
    'Software Engineer',
    'UI/UX Designer',
    'Product Manager',
    'Marketing Specialist'
  ];

  File? _imageFile; // Biến lưu trữ File hình ảnh được chọn hoặc chụp

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Employee'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedDepartment,
              onChanged: (value) {
                setState(() {
                  selectedDepartment = value!;
                });
              },
              items: departments.map((department) {
                return DropdownMenuItem(
                  value: department,
                  child: Text(department),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Department',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedAccountType,
              onChanged: (value) {
                setState(() {
                  selectedAccountType = value!;
                });
              },
              items: accountTypes.map((accountType) {
                return DropdownMenuItem(
                  value: accountType,
                  child: Text(accountType),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Account Type',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('Gender:'),
                SizedBox(width: 16.0),
                ...genders.map((gender) {
                  return Row(
                    children: [
                      Radio(
                        value: gender,
                        groupValue: selectedGender,
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value.toString();
                          });
                        },
                      ),
                      Text(gender),
                    ],
                  );
                }).toList(),
              ],
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedPosition,
              onChanged: (value) {
                setState(() {
                  selectedPosition = value!;
                });
              },
              items: positions.map((position) {
                return DropdownMenuItem(
                  value: position,
                  child: Text(position),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Position',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            _imageFile == null
                ? ElevatedButton(
              onPressed: () {
                _getImage(ImageSource.gallery);
              },
              child: Text('Select Image'),
            )
                : Image.file(
              _imageFile!,
              height: 150.0,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn nút Thêm nhân viên
                String name = nameController.text;
                String address = addressController.text;
                String email = emailController.text;

                // Tạo đối tượng nhân viên mới
                Employee newEmployee = Employee(
                  name: name,
                  address: address,
                  email: email,
                  department: selectedDepartment,
                  accountType: selectedAccountType,
                  gender: selectedGender,
                  position: selectedPosition,
                  imageFile: _imageFile,
                );

                // Thêm vào danh sách nhân viên
                // (Bạn có thể lưu trữ vào cơ sở dữ liệu hoặc danh sách tùy theo yêu cầu)
                print('Thêm nhân viên: $newEmployee');

                // Đặt lại các trường nhập liệu về trạng thái ban đầu
                nameController.clear();
                addressController.clear();
                emailController.clear();
                setState(() {
                  selectedDepartment = 'IT';
                  selectedAccountType = 'Normal';
                  selectedGender = 'Male';
                  selectedPosition = 'Software Engineer';
                  _imageFile = null; // Đặt lại hình ảnh về null sau khi thêm nhân viên
                });
              },
              child: Text('Add Employee'),
            ),
          ],
        ),
      ),
    );
  }
}*/