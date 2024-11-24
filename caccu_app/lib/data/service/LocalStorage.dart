import 'package:hive/hive.dart';

class LocalStorageService {
  final Box _userBox = Hive.box('userBox');

  Future<void> saveUserEmail(String email) async {
    await _userBox.put('email', email);
  }

  String? getUserEmail() {
    return _userBox.get('email') ?? '';
  }

  Future<void> clearUserEmail() async {
    await _userBox.delete('email');
  }

  Future<void> saveUserId(String userId) async {
    await _userBox.put('userId', userId);
  }

  String? getUserId() {
    return _userBox.get('userId') ?? '';
  }

  Future<void> clearUserId() async {
    await _userBox.delete('userId');
  }
}
