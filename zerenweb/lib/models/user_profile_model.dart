class UserProfile {
  final int? userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String deliveryAddress;

  UserProfile({
    this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.deliveryAddress,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'delivery_address': deliveryAddress,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      userId: map['user_id'] as int?,
      name: map['name'] as String? ?? 'Valued Customer',
      email: map['email'] as String? ?? 'customer@zeren.com',
      phoneNumber: map['phone_number'] as String? ?? '+92 300 1234567',
      deliveryAddress: map['delivery_address'] as String? ?? 'House 123, Street 4, Islamabad',
    );
  }

  UserProfile copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? deliveryAddress,
  }) {
    return UserProfile(
      userId: this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
    );
  }
}
