import 'package:caccu_app/data/entity/userEntity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../entity/billEntity.dart';

class BillRepository{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Thêm mới giao dịch
  Future<void> addBill(BillEntity bill) async {
    await _db.collection('bills').add(bill.toMap());
  }

  // Cập nhật giao dịch
  Future<void> updateBill(String billId, Map<String, dynamic> updatedData) async {
    await _db.collection('bills').doc(billId).update(updatedData);
  }

  // Xóa giao dịch
  Future<void> deleteUser(String billId) async {
    await _db.collection('bills').doc(billId).delete();
  }
}