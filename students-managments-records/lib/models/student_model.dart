class StudentModel {
  final int? id;
  final String fullName;
  final String rollNumber;
  final String email;
  final String phone;
  final String department;
  final String semester;
  final String section;
  final String gender;
  final String address;
  final String cgpa;
  final String? photoPath;
  final String createdAt;
  final String updatedAt;

  StudentModel({
    this.id,
    required this.fullName,
    required this.rollNumber,
    required this.email,
    required this.phone,
    required this.department,
    required this.semester,
    required this.section,
    required this.gender,
    required this.address,
    required this.cgpa,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'full_name': fullName,
      'roll_number': rollNumber,
      'email': email,
      'phone': phone,
      'department': department,
      'semester': semester,
      'section': section,
      'gender': gender,
      'address': address,
      'cgpa': cgpa,
      'photo_path': photoPath,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'] as int?,
      fullName: map['full_name'] as String? ?? '',
      rollNumber: map['roll_number'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      department: map['department'] as String? ?? '',
      semester: map['semester'] as String? ?? '',
      section: map['section'] as String? ?? '',
      gender: map['gender'] as String? ?? '',
      address: map['address'] as String? ?? '',
      cgpa: map['cgpa'] as String? ?? '3.00',
      photoPath: map['photo_path'] as String?,
      createdAt: map['created_at'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt: map['updated_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  StudentModel copyWith({
    int? id,
    String? fullName,
    String? rollNumber,
    String? email,
    String? phone,
    String? department,
    String? semester,
    String? section,
    String? gender,
    String? address,
    String? cgpa,
    String? photoPath,
    String? createdAt,
    String? updatedAt,
  }) {
    return StudentModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      rollNumber: rollNumber ?? this.rollNumber,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      section: section ?? this.section,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      cgpa: cgpa ?? this.cgpa,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Formats initials for avatar display
  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.isEmpty || parts.first.isEmpty) return 'S';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
