class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role; // 'admin' atau 'client'
  final String approvalStatus; // 'pending', 'approved', atau 'rejected'

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.approvalStatus,
  });

  // Mengubah data dari Firestore (Map) ke format aplikasi (Object)
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? 'No Name',
      role: data['role'] ?? 'client',
      approvalStatus: data['approvalStatus'] ?? 'pending',
    );
  }

  // Mengubah data aplikasi ke format Firestore (Map) untuk disimpan
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'approvalStatus': approvalStatus,
    };
  }
}
