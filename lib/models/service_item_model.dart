class ServiceItemModel {
  final int id;
  final String name;
  final num price;
  final String unit;
  final String type; // 'kiloan' or 'satuan'
  final String? description;

  ServiceItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    required this.type,
    this.description,
  });

  factory ServiceItemModel.fromJson(Map<String, dynamic> json) {
    return ServiceItemModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '1') ?? 1,
      name: json['name'] ?? json['nama'] ?? 'Layanan',
      price: json['price'] is num
          ? json['price']
          : num.tryParse(json['price']?.toString().replaceAll(RegExp(r'\D'), '') ?? '0') ?? 0,
      unit: json['unit'] ?? json['satuan'] ?? 'Kg',
      type: json['type'] ?? 'kiloan',
      description: json['description'] ?? json['deskripsi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'unit': unit,
      'type': type,
      'description': description,
    };
  }
}
