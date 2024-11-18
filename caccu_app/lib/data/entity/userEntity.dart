// lib/data/models/user_model.dart

class UserEntity {
  String? userId;
  String name;
  String password;
  String phone;
  String email;
  bool status;

  UserEntity({
    this.userId,
    required this.name,
    required this.password,
    required this.phone,
    required this.email,
    required this.status,
  });

  // Chuyển đổi từ Map (Firestore) sang User
  factory UserEntity.fromMap(Map<String, dynamic> data, String documentId) {
    return UserEntity(
      userId: documentId,
      name: data['name'] ?? '',
      password: data['password'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      status: data['status'] ?? '',
    );
  }

  // Chuyển đổi từ User sang Map để lưu lên Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'password': password,
      'phone': phone,
      'email': email,
      'status': status,
    };
  }
}
