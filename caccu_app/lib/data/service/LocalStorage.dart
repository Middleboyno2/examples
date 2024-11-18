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
}
