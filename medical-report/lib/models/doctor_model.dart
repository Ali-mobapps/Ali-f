class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String phone;
  final String? whatsapp;
  final String qualifications;
  final String hospitalName;
  final String hospitalAddress;
  final String? photoUrl;
  final String? pmdcNo;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.phone,
    this.whatsapp,
    required this.qualifications,
    required this.hospitalName,
    required this.hospitalAddress,
    this.photoUrl,
    this.pmdcNo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'phone': phone,
      'whatsapp': whatsapp,
      'qualifications': qualifications,
      'hospitalName': hospitalName,
      'hospitalAddress': hospitalAddress,
      'photoUrl': photoUrl,
      'pmdcNo': pmdcNo,
    };
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      specialty: map['specialty'] ?? '',
      phone: map['phone'] ?? '',
      whatsapp: map['whatsapp'],
      qualifications: map['qualifications'] ?? '',
      hospitalName: map['hospitalName'] ?? '',
      hospitalAddress: map['hospitalAddress'] ?? '',
      photoUrl: map['photoUrl'],
      pmdcNo: map['pmdcNo'],
    );
  }
}
