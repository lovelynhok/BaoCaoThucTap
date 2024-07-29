import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart'; // Import thư viện intl
import 'models/employee_model.dart';
import 'providers/employee_provider.dart';

class EmployeeFormPage extends StatefulWidget {
  final ApiService apiService;
  final Employee? employee;

  EmployeeFormPage({required this.apiService, this.employee});

  @override
  _EmployeeFormPageState createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _salaryController;
  late TextEditingController _addressController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late TextEditingController _hiredDateController;
  String? _selectedPosition;
  bool _isActive = true;
  DateTime? _hiredDate;
  File? _avatar;

  final List<String> _positions = ['Manager', 'Developer', 'Designer', 'Tester'];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final employee = widget.employee;
    _nameController = TextEditingController(text: employee?.name ?? '');
    _salaryController = TextEditingController(text: employee?.salary.toString() ?? '');
    _addressController = TextEditingController(text: employee?.address ?? '');
    _phoneNumberController = TextEditingController(text: employee?.phoneNumber ?? '');
    _emailController = TextEditingController(text: employee?.email ?? '');
    _selectedPosition = employee?.position;
    _hiredDate = employee?.hiredDate;
    _hiredDateController = TextEditingController(text: _hiredDate != null ? DateFormat('yyyy-MM-dd').format(_hiredDate!) : '');
    _isActive = employee?.isActive ?? true;
    if (employee?.avatarPath != null) {
      _avatar = File(employee!.avatarPath!);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _hiredDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _hiredDate) {
      setState(() {
        _hiredDate = pickedDate;
        _hiredDateController.text = DateFormat('yyyy-MM-dd').format(_hiredDate!);
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatar = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee == null ? 'Thêm Nhân Viên' : 'Sửa Nhân Viên'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildAvatarPicker(),
              _buildTextFormField(
                controller: _nameController,
                labelText: 'Họ và Tên',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui Lòng Nhập Tên';
                  }
                  return null;
                },
              ),
              _buildDropdownField(
                value: _selectedPosition,
                items: _positions,
                onChanged: (value) {
                  setState(() {
                    _selectedPosition = value;
                  });
                },
              ),
              _buildTextFormField(
                controller: _salaryController,
                labelText: 'Lương',
                keyboardType: TextInputType.number,
              ),
              _buildTextFormField(
                controller: _addressController,
                labelText: 'Địa chỉ',
              ),
              _buildTextFormField(
                controller: _phoneNumberController,
                labelText: 'Số Điện Thoại',
              ),
              _buildTextFormField(
                controller: _emailController,
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              _buildDatePickerField(
                context: context,
                controller: _hiredDateController,
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 16),
              SwitchListTile(
                title: Text('Hoạt Động'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
                activeColor: Colors.teal,
                secondary: Icon(Icons.check_circle, color: Colors.teal),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final employee = Employee(
                      id: widget.employee?.id ?? 0,
                      name: _nameController.text,
                      position: _selectedPosition ?? '',
                      salary: double.parse(_salaryController.text),
                      hiredDate: _hiredDate!,
                      address: _addressController.text,
                      phoneNumber: _phoneNumberController.text,
                      email: _emailController.text,
                      isActive: _isActive,
                      avatarPath: _avatar != null ? _avatar!.path : null,
                    );
                    try {
                      if (widget.employee == null) {
                        await widget.apiService.addEmployee(employee, _avatar);
                      } else {
                        await widget.apiService.updateEmployee(employee, _avatar);
                      }
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lưu Thất Bại')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  widget.employee == null ? 'Thêm Nhân Viên' : 'Cập nhật nhân viên',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value != null && items.contains(value) ? value : items.isNotEmpty ? items[0] : null,
        decoration: InputDecoration(
          labelText: 'Vị Trí',
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) => value == null || value.isEmpty ? 'Vui lòng chọn vị trí' : null,
      ),
    );
  }

  Widget _buildDatePickerField({
    required BuildContext context,
    required TextEditingController controller,
    required void Function() onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Ngày Thuê (yyyy-mm-dd)',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          _avatar != null
              ? CircleAvatar(
            radius: 40,
            backgroundImage: FileImage(_avatar!),
          )
              : CircleAvatar(
            radius: 40,
            child: Icon(Icons.person, size: 40),
          ),
          SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.add_a_photo),
            label: Text('Chọn ảnh đại diện'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
