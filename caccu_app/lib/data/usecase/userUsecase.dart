import 'package:flutter/cupertino.dart';

import '../entity/userEntity.dart';
import '../repository/userRepo.dart';

class UserUseCase {
  final UserRepository _userRepository = UserRepository();

  // Thêm người dùng mới
  Future<void> addUser(UserEntity user) async {
    await _userRepository.addUser(user);
  }

  // Cập nhật người dùng
  Future<void> updateUser(String userId, Map<String, dynamic> updatedData) async {
    await _userRepository.updateUser(userId, updatedData);
  }

  // Xóa người dùng
  Future<void> deleteUser(String userId) async {
    await _userRepository.deleteUser(userId);
  }

  //====================================================================================
  // kiểm tra thông tin đăng nhập
  Future<bool> checkUserCredentials(String email, String password) async {
    return await _userRepository.checkUserCredentials(email, password);
  }
  // check email đã có tồn tại hay chưa
  Future<bool> checkEmail(String email) async{
    return await _userRepository.checkEmail(email);
  }
  // update status
  Future<bool> checkAndUpdateUserStatus(String? email) async{
    return await _userRepository.checkAndUpdateUserStatus(email);
  }
  Future<UserEntity?> getUserByEmail(String email){
    return _userRepository.getUserByEmail(email);
  }

  //=============================================================================


  Future<void> resetPassword(BuildContext context, String email){
    return _userRepository.resetPassword(context, email);
  }
  Future<void> sendPasswordEmail(String recipientEmail, String password){
    return _userRepository.sendPasswordEmail(recipientEmail, password);
  }

  Future<void> createAccountAuthenticated({
    required String email,
    required String password
  }){
    return _userRepository.createAccountAuthenticated(email: email, password: password);
  }
}