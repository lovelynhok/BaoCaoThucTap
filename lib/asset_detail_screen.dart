import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thư viện cho định dạng ngày
import 'models/asset.dart';

class AssetDetailPage extends StatelessWidget {
  final Asset asset;
  final Function(Asset) onUpdate;

  AssetDetailPage({required this.asset, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: asset.name);
    final descriptionController = TextEditingController(text: asset.description);
    final purchaseDateController = TextEditingController(text: asset.purchaseDate);
    final valueController = TextEditingController(text: asset.value.toString());

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.tryParse(asset.purchaseDate) ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != DateTime.tryParse(asset.purchaseDate)) {
        purchaseDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Asset Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
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
                final updatedAsset = Asset(
                  id: asset.id,
                  name: nameController.text,
                  description: descriptionController.text,
                  purchaseDate: purchaseDateController.text,
                  value: double.tryParse(valueController.text) ?? 0.0,
                  imagePath: asset.imagePath,
                  location: asset.location,
                );
                onUpdate(updatedAsset);
                Navigator.pop(context);
              },
              child: Text('Update Asset'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0), backgroundColor: Colors.blueAccent,
                textStyle: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
