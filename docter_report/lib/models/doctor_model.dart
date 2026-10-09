class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final String? avatarUrl;
  final String? phone;
  final String? email;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    this.avatarUrl,
    this.phone,
    this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'hospital': hospital,
      'avatar_url': avatarUrl,
      'phone': phone,
      'email': email,
    };
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      specialty: map['specialty'] ?? '',
      hospital: map['hospital'] ?? '',
      avatarUrl: map['avatar_url'],
      phone: map['phone'],
      email: map['email'],
    );
  }
}
