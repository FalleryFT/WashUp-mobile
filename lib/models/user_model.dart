class UserModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? noHp;
  final String? alamat;
  final String role;
  final String? memberSejak;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.noHp,
    this.alamat,
    this.role = 'customer',
    this.memberSejak,
  });

  String get idFormatted => 'ID: ${id.toString().padLeft(4, '0')}';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '1') ?? 1,
      name: json['name'] ?? json['nama'] ?? json['username'] ?? 'Pelanggan',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      noHp: json['no_hp'] ?? json['noHp'] ?? json['phone'],
      alamat: json['alamat'] ?? json['address'],
      role: json['role'] ?? 'customer',
      memberSejak: json['memberSejak'] ?? json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'no_hp': noHp,
      'alamat': alamat,
      'role': role,
      'memberSejak': memberSejak,
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? username,
    String? email,
    String? noHp,
    String? alamat,
    String? role,
    String? memberSejak,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      noHp: noHp ?? this.noHp,
      alamat: alamat ?? this.alamat,
      role: role ?? this.role,
      memberSejak: memberSejak ?? this.memberSejak,
    );
  }
}
