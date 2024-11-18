// lib/data/repository/transaction_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../entity/transactionEntity.dart';


class TransactionRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Thêm mới giao dịch
  Future<void> addTransaction(TransactionEntity transaction) async {
    await _db.collection('transactions').add(transaction.toMap());
  }

  // Cập nhật giao dịch
  Future<void> updateTransaction(String transactionId, Map<String, dynamic> updatedData) async {
    await _db.collection('transactions').doc(transactionId).update(updatedData);
  }

  // Xóa giao dịch
  Future<void> deleteTransaction(String transactionId) async {
    await _db.collection('transactions').doc(transactionId).delete();
  }

  // Stream để lắng nghe danh sách giao dịch theo người dùng
  Stream<List<TransactionEntity>> getTransactionsByUserStream(String userId) {
    return _db.collection('transactions')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => TransactionEntity.fromMap(doc.data(), doc.id)).toList()
    );
  }

  // Stream để lắng nghe danh sách giao dịch theo người dùng
  Stream<List<TransactionEntity>> getTransactions() {
    return _db.collection('transactions')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => TransactionEntity.fromMap(doc.data(), doc.id)).toList()
    );
  }
}
