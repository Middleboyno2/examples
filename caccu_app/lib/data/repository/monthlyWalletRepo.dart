import 'package:caccu_app/data/entity/monthlyWalletEntity.dart';
import 'package:caccu_app/data/entity/userEntity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MonthlyWalletRepository{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Thêm mới ví tháng
  Future<void> addMonthlyWallet(MonthlyWalletEntity monthlyWallet) async {
    await _db.collection('monthly_wallet').add(monthlyWallet.toMap());
  }

  // Cập nhật ví tháng
  Future<void> updateMonthlyWallet(String monthlyWalletId, Map<String, dynamic> updatedData) async {
    await _db.collection('monthly_wallet').doc(monthlyWalletId).update(updatedData);
  }

  // Xóa ví tháng
  Future<void> deleteMonthlyWallet(String monthlyWalletId) async {
    await _db.collection('monthly_wallet').doc(monthlyWalletId).delete();
  }
}