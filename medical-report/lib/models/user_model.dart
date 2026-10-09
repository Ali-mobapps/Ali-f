class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String? lastSyncTime;
  final bool isDriveConnected;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.lastSyncTime,
    this.isDriveConnected = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'lastSyncTime': lastSyncTime,
      'isDriveConnected': isDriveConnected ? 1 : 0,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      photoUrl: map['photoUrl'],
      lastSyncTime: map['lastSyncTime'],
      isDriveConnected: map['isDriveConnected'] == 1,
    );
  }
}
