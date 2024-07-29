import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/asset.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.6:3000/asset';

  Future<List<Asset>> fetchAssets() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Asset.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load assets');
    }
  }

  Future<void> deleteAsset(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete asset');
    }
  }

  Future<void> updateAsset(Asset asset) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${asset.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(asset.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update asset');
    }
  }

  Future<void> addAsset(Asset asset) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(asset.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add asset');
    }
  }
}
