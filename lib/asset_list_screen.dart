import 'package:flutter/material.dart';
import 'providers/asset_provider.dart'; // Giả sử bạn đã có file này để kết nối API
import 'models/asset.dart';
import 'asset_detail_screen.dart';
import 'add_asset_screen.dart';

class AssetListPage extends StatefulWidget {
  @override
  _AssetListPageState createState() => _AssetListPageState();
}

class _AssetListPageState extends State<AssetListPage> {
  late Future<List<Asset>> _assets;

  @override
  void initState() {
    super.initState();
    _assets = ApiService().fetchAssets();
  }

  void _deleteAsset(int id) async {
    try {
      await ApiService().deleteAsset(id);
      setState(() {
        _assets = ApiService().fetchAssets();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete asset: $e')),
      );
    }
  }

  void _updateAsset(Asset asset) async {
    try {
      await ApiService().updateAsset(asset);
      setState(() {
        _assets = ApiService().fetchAssets();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update asset: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asset Management', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Tìm kiếm tài sản nếu cần
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Asset>>(
        future: _assets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No assets found.'));
          } else {
            final assets = snapshot.data!;
            return ListView.builder(
              itemCount: assets.length,
              itemBuilder: (context, index) {
                final asset = assets[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 4.0,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: asset.imagePath != null
                        ? Image.network(
                      asset.imagePath!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.image, size: 50);
                      },
                    )
                        : Icon(Icons.image, size: 50),
                    title: Text(asset.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Value: \$${asset.value.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteAsset(asset.id);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssetDetailPage(
                            asset: asset,
                            onUpdate: (updatedAsset) {
                              _updateAsset(updatedAsset);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAssetPage(
                onAdd: (newAsset) {
                  ApiService().addAsset(newAsset).then((_) {
                    setState(() {
                      _assets = ApiService().fetchAssets();
                    });
                  }).catchError((e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add asset: $e')),
                    );
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
