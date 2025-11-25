class UserEntity {
  const UserEntity({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.phone,
    this.preferredLanguage = 'tr',
    this.interests = const [],
  });

  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final String? phone;
  final String preferredLanguage;
  final List<String> interests;

  UserEntity copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
    String? phone,
    String? preferredLanguage,
    List<String>? interests,
  }) {
    return UserEntity(
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

