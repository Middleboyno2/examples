import 'package:caccu_app/data/entity/userEntity.dart';
import 'package:caccu_app/data/service/LocalStorage.dart';
import 'package:caccu_app/theme/AppPass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class UserRepository{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createAccountAuthenticated({
   required String email,
   required String password
  }) async{
    try{
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
    }on FirebaseAuthException catch(e){
      String mess = "";
      if(e.code == 'weak-password'){
        mess = 'The password provided is too weak';
      }else if (e.code == 'email-already-in-use'){
        mess = 'An account already exists with that email';
      }
      Fluttertoast.showToast(
        msg: mess,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.deepPurple.shade300,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> sendPasswordEmail(String recipientEmail, String password) async {
    // Cấu hình email gửi đi
    const String senderEmail = 'loi2003zzz@gmail.com'; // Email của bạn
    String senderPassword = senderAppPassword; // Mật khẩu ứng dụng của email (App Password)

    // Cấu hình SMTP server (ở đây là Gmail)
    final smtpServer = gmail(senderEmail, senderPassword);

    // Nội dung email
    final message = Message()
      ..from = Address(senderEmail, 'Caccu App') // Tên hiển thị của email gửi
      ..recipients.add(recipientEmail) // Email nhận
      ..subject = 'Your Password:' // Tiêu đề email
      ..text = 'Hello,\n\nYour new password is: $password\n\nThank you!'; // Nội dung email

    try {
      // Gửi email
      await send(message, smtpServer);
      Fluttertoast.showToast(
        msg: 'Email sent successfully to $recipientEmail',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.deepPurple.shade300,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      print('Email sent successfully to $recipientEmail');
    } catch (e) {
      print('Error sending email: $e');
      throw Exception('Failed to send email');
    }
  }



  // Hàm gửi email đặt lại mật khẩu
  Future<bool> resetPassword(BuildContext context, String email) async {

    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      return true; // Thành công
    }on FirebaseAuthException catch (e) {
      print("Error sending password reset email: $e");
      showDialog(context: context,
        builder: (context){
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        }
      );
      return false; // Thất bại
    }
  }
//=================================================================================
  Future<UserEntity?> getUserByEmail(String email) async {
    try {
      // Reference to the 'users' collection in Firestore
      CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

      // Query Firestore to find the user with the specified email
      QuerySnapshot querySnapshot = await usersRef.where('email', isEqualTo: email).limit(1).get();

      // Check if a user with the given email exists
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document and convert it to UserEntity
        var userDoc = querySnapshot.docs.first;
        return UserEntity.fromMap(userDoc.data() as Map<String, dynamic>, userDoc.id);
      } else {
        // No user found with the specified email
        print("No user found with email: $email");
        return null;
      }
    } catch (e) {
      print("Error fetching user by email: $e");
      return null;
    }
  }

  //==============================================================================
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
      var userDoc = snapshot.docs.first;
      var userData = userDoc.data() as Map<String, dynamic>;

      // Kiểm tra mật khẩu có đúng không
      if (userData['password'] == password) {
        String userId = userDoc.id; // Lấy userId từ tài liệu
        LocalStorageService().saveUserId(userId);
        print(LocalStorageService().getUserId());// Lưu userId vào LocalStorage
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