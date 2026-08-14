class ProfileEntity {
  final String name;
  final String email;
  final String role;
  final String? profileImageUrl;
  final String? phone;

  ProfileEntity({
    required this.name,
    required this.email,
    required this.role,
    this.profileImageUrl,
    this.phone,
  });
}
