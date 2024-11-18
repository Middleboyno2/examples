import 'package:caccu_app/data/entity/userEntity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../entity/walletEntity.dart';

class WalletRepository{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Thêm mới ví
  Future<void> addWallet(WalletEntity wallet) async {
    await _db.collection('wallet').add(wallet.toMap());
  }

  // Cập nhật ví
  Future<void> updateWallet(String walletId, Map<String, dynamic> updatedData) async {
    await _db.collection('wallet').doc(walletId).update(updatedData);
  }

  // Xóa ví
  Future<void> deleteWallet(String walletId) async {
    await _db.collection('wallet').doc(walletId).delete();
  }
}