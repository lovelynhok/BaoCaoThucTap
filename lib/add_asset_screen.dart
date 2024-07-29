import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thư viện để định dạng ngày
import 'models/asset.dart';

class AddAssetPage extends StatelessWidget {
  final Function(Asset) onAdd;

  AddAssetPage({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final purchaseDateController = TextEditingController();
    final valueController = TextEditingController();

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != DateTime.now()) {
        purchaseDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Asset'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter the asset name' : null,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: purchaseDateController,
                    decoration: InputDecoration(
                      labelText: 'Purchase Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: valueController,
                decoration: InputDecoration(
                  labelText: 'Value',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  final newAsset = Asset(
                    id: 0, // Đặt ID là 0 hoặc giá trị mặc định cho mới
                    name: nameController.text,
                    description: descriptionController.text,
                    purchaseDate: purchaseDateController.text,
                    value: double.tryParse(valueController.text) ?? 0.0,
                    imagePath: null,
                    location: null,
                  );
                  onAdd(newAsset);
                  Navigator.pop(context);
                },
                child: Text('Add Asset'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0), backgroundColor: Colors.blueAccent,
                  textStyle: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
