import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.fullName,
    super.avatarUrl,
    super.phone,
    super.preferredLanguage,
    super.interests,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      phone: json['phone'] as String?,
      preferredLanguage: json['preferred_language'] as String? ?? 'tr',
      interests: const [], // Ayrı tablodan yüklenecek
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'phone': phone,
      'preferred_language': preferredLanguage,
    };
  }

  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
    String? phone,
    String? preferredLanguage,
    List<String>? interests,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      interests: interests ?? this.interests,
    );
  }
}

