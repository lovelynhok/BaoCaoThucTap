
import 'package:flutter/material.dart';
class Money extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quản lí tài sản',
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
      body: AssetManagementScreen(),
    );

  }
}


class AssetManagementScreen extends StatefulWidget {
  @override
  _AssetManagementScreenState createState() => _AssetManagementScreenState();
}

class _AssetManagementScreenState extends State<AssetManagementScreen> {
  final List<AssetRecord> assetRecords = [
    AssetRecord(
      name: 'Laptop',
      description: 'Dell XPS 13',
      value: '\$1200',
      imageUrl: 'assets/laptop.jpg',
      status: 'Available',
    ),
    AssetRecord(
      name: 'Smartphone',
      description: 'iPhone 12',
      value: '\$999',
      imageUrl: 'assets/iphone.jpg',
      status: 'In Use',
    ),
    // Thêm nhiều bản ghi tài sản khác
  ];

  void _addAsset() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssetFormScreen(),
      ),
    );
    if (result != null && result is AssetRecord) {
      setState(() {
        assetRecords.add(result);
      });
    }
  }

  void _editAsset(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssetFormScreen(record: assetRecords[index]),
      ),
    );
    if (result != null && result is AssetRecord) {
      setState(() {
        assetRecords[index] = result;
      });
    }
  }

  void _deleteAsset(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this asset?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                assetRecords.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: assetRecords.length,
          itemBuilder: (context, index) {
            final record = assetRecords[index];
            return Card(
              elevation: 4.0,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(record.imageUrl),
                ),
                title: Text(
                  record.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4.0),
                    Text(record.description),
                    SizedBox(height: 4.0),
                    Text('Value: ${record.value}'),
                    SizedBox(height: 4.0),
                    Text('Status: ${record.status}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: () => _editAsset(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteAsset(index),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssetDetailScreen(record: record),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAsset,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

class AssetFormScreen extends StatefulWidget {
  final AssetRecord? record;

  AssetFormScreen({this.record});

  @override
  _AssetFormScreenState createState() => _AssetFormScreenState();
}

class _AssetFormScreenState extends State<AssetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late String _value;
  late String _imageUrl;
  late String _status;

  @override
  void initState() {
    super.initState();
    if (widget.record != null) {
      _name = widget.record!.name;
      _description = widget.record!.description;
      _value = widget.record!.value;
      _imageUrl = widget.record!.imageUrl;
      _status = widget.record!.status;
    } else {
      _name = '';
      _description = '';
      _value = '';
      _imageUrl = 'assets/placeholder.jpg';
      _status = 'Available';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record == null ? 'Add Asset' : 'Edit Asset'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the asset name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the asset description';
                  }
                  return null;
                },
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                initialValue: _value,
                decoration: InputDecoration(labelText: 'Value'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the asset value';
                  }
                  return null;
                },
                onSaved: (value) => _value = value!,
              ),
              TextFormField(
                initialValue: _imageUrl,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the asset image URL';
                  }
                  return null;
                },
                onSaved: (value) => _imageUrl = value!,
              ),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(labelText: 'Status'),
                items: ['Available', 'In Use', 'Maintenance']
                    .map((status) => DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) => setState(() {
                  _status = value!;
                }),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(
                      context,
                      AssetRecord(
                        name: _name,
                        description: _description,
                        value: _value,
                        imageUrl: _imageUrl,
                        status: _status,
                      ),
                    );
                  }
                },
                child: Text(widget.record == null ? 'Add' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AssetDetailScreen extends StatelessWidget {
  final AssetRecord record;

  AssetDetailScreen({required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(record.name),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage(record.imageUrl),
                radius: 50.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Name: ${record.name}',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Description: ${record.description}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Value: ${record.value}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Status: ${record.status}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

class AssetRecord {
  final String name;
  final String description;
  final String value;
  final String imageUrl;
  final String status;

  AssetRecord({
    required this.name,
    required this.description,
    required this.value,
    required this.imageUrl,
    required this.status,
  });
}