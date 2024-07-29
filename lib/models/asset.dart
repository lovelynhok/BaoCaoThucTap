class Asset {
  final int id;
  final String name;
  final String description;
  final String purchaseDate;
  final double value;
  final String? imagePath; // Có thể là null
  final String? location;  // Có thể là null

  Asset({
    required this.id,
    required this.name,
    required this.description,
    required this.purchaseDate,
    required this.value,
    this.imagePath,  // Có thể là null
    this.location,   // Có thể là null
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'] ?? 0,
      name: json['name'] ?? '', // Cung cấp giá trị mặc định nếu null
      description: json['description'] ?? '', // Cung cấp giá trị mặc định nếu null
      purchaseDate: json['purchase_date'] ?? '', // Cung cấp giá trị mặc định nếu null
      value: (json['value'] is String
          ? double.tryParse(json['value']) ?? 0.0
          : (json['value'] as double?)) ?? 0.0,
      imagePath: json['image_path'] as String?, // Chấp nhận giá trị null
      location: json['location'] as String?, // Chấp nhận giá trị null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'purchase_date': purchaseDate,
      'value': value,
      'image_path': imagePath, // Có thể là null
      'location': location,   // Có thể là null
    };
  }
}
