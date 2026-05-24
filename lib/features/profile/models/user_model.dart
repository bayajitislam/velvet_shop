// ─────────────────────────────────────────────────────────
//  UserModel
// ─────────────────────────────────────────────────────────

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? phone;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'phone': phone,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    String? phone,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
    );
  }

  // ── Dummy user for testing without backend ─────────────
  static UserModel get dummy => const UserModel(
        id: 'user_001',
        name: 'Bayajit Islam',
        email: 'realbayajitislam@email.com',
        avatarUrl: 'https://bayajitislam.com/bayajitislam.jpeg',
        phone: '+880123456789',
      );
}