enum UserRole { admin, student }

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String universityId;
  final String department;
  final UserRole role;
  final bool isApproved;
  final double outstandingFines;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.universityId,
    required this.department,
    required this.role,
    this.isApproved = false,
    this.outstandingFines = 0.0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      universityId: json['university_id'],
      department: json['department'],
      role: json['role'] == 'admin' ? UserRole.admin : UserRole.student,
      isApproved: json['is_approved'] ?? false,
      outstandingFines: (json['outstanding_fines'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'university_id': universityId,
      'department': department,
      'role': role == UserRole.admin ? 'admin' : 'student',
      'is_approved': isApproved,
      'outstanding_fines': outstandingFines,
    };
  }

  UserModel copyWith({
    bool? isApproved,
    double? outstandingFines,
  }) {
    return UserModel(
      id: id,
      fullName: fullName,
      email: email,
      universityId: universityId,
      department: department,
      role: role,
      isApproved: isApproved ?? this.isApproved,
      outstandingFines: outstandingFines ?? this.outstandingFines,
    );
  }
}
