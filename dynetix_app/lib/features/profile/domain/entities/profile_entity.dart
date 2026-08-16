class ProfileEntity {
  final String name;
  final String email;
  final String role;
  final String? profileImageUrl;
  final String? phone;
  final String? gender;

  ProfileEntity({
    required this.name,
    required this.email,
    required this.role,
    this.profileImageUrl,
    this.phone,
    this.gender,
  });

  ProfileEntity copyWith({
    String? name,
    String? email,
    String? role,
    String? profileImageUrl,
    String? phone,
    String? gender,
  }) {
    return ProfileEntity(
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
    );
  }
}
