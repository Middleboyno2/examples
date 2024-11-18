import 'package:caccu_app/data/entity/userEntity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Thêm mới người dùng
  Future<void> addUser(UserEntity user) async {
    await _db.collection('users').add(user.toMap());
  }

  // Cập nhật người dùng
  Future<void> updateUser(String userId, Map<String, dynamic> updatedData) async {
    await _db.collection('users').doc(userId).update(updatedData);
  }

  // Xóa người dùng
  Future<void> deleteUser(String userId) async {
    await _db.collection('users').doc(userId).delete();
  }


  // Hàm kiểm tra thông tin đăng nhập
  Future<bool> checkUserCredentials(String email, String password) async {
    try {
      // Tìm user trong Firestore dựa trên email
      QuerySnapshot snapshot = await _db
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isEmpty) {
        // Không tìm thấy user với email đã nhập
        return false;
      }

      // Lấy user đầu tiên từ kết quả
      var userData = snapshot.docs.first.data() as Map<String, dynamic>;

      // Kiểm tra mật khẩu có đúng không
      if (userData['password'] == password) {
        return true; // Thông tin hợp lệ
      } else {
        return false; // Mật khẩu không đúng
      }
    } catch (e) {
      print('Error checking user credentials: $e');
      return false; // Lỗi khi kiểm tra thông tin
    }
  }


  // Hàm kiểm tra email đã tồn tại trên Firestore chưa
  Future<bool> checkEmail(String email) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if( snapshot.docs.isNotEmpty){
        return true;
      }

      return false;
    } catch (e) {
      print('Error checking email: $e');
      return false; // Xử lý lỗi theo cách bạn muốn
    }
  }

  // Hàm kiểm tra và cập nhật trạng thái tài khoản bằng email
  Future<bool> checkAndUpdateUserStatus(String? email) async {
    try {
      // Truy vấn tài liệu trong collection 'users' với điều kiện email khớp
      QuerySnapshot snapshot = await _db
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = snapshot.docs.first;
        // bool currentStatus = userDoc['status'] ?? false;

        // Nếu tài khoản chưa đăng nhập lần đầu, cập nhật trạng thái
        if (userDoc['status'] == false) {
          await _db.collection('users').doc(userDoc.id).update({'status': true});
          return true; // Đăng nhập lần đầu thành công
        }

        // Tài khoản đã từng đăng nhập, chuyển sang Home
        return true;
      } else {
        // Tài khoản không tồn tại
        return false;
      }
    } catch (e) {
      print('Error checking/updating user status: $e');
      return false; // Xử lý lỗi
    }
  }
}