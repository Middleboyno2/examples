// lib/services/transaction_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import '../entity/transactionEntity.dart';
import '../repository/transactionRepo.dart';

class TransactionUseCase {
  final TransactionRepository _transactionRepository = TransactionRepository();

  Future<void> addTransaction(TransactionEntity transaction)async {
    await _transactionRepository.addTransaction(transaction);
  }

  // Thêm giao dịch mới
  Future<bool> addTransaction2(String userId,
      String categoryId,
      String walletId,
      double price,
      String notes,
      DateTime time) async {
    return await _transactionRepository.addTransaction2(
      userId,
      categoryId,
      walletId,
      price,
      notes,
      time
    );
  }

  // Cập nhật giao dịch
  Future<bool> updateTransaction(String transactionId, Map<String, dynamic> updatedData) async {
    return await _transactionRepository.updateTransaction(transactionId, updatedData);
  }

  Future<bool> updateTransaction2(
      String transactionId, // ID của giao dịch cần cập nhật
      String userId,
      String categoryId,
      String walletId,
      double price,
      String notes,
      DateTime time,
      ) async{
    return await _transactionRepository.updateTransaction2(transactionId, userId, categoryId, walletId, price, notes, time);
  }

  // Xóa giao dịch
  Future<bool> deleteTransaction(String transactionId) async {
    return await _transactionRepository.deleteTransaction(transactionId);
  }

  // Lấy danh sách giao dịch của người dùng
  // cái này phải xem laị, lỗi vcl
  Stream<List<TransactionEntity>> getTransactionsByUser(String userId) {
    return _transactionRepository.getTransactionsByUserStream(userId);
  }
  // Lấy danh sách giao dịch của người dùng
  Stream<List<TransactionEntity>> getTransactions() {
    return _transactionRepository.getTransactions();
  }

  Future<List<TransactionEntity>> getTransactionsByUserAndMonth(String userId, int month){
    return _transactionRepository.getTransactionsByUserAndMonth(userId, month);
  }

  Future<List<double>> getTotalPriceByWalletIds(String userId, List<String> walletIds){
    return _transactionRepository.getTotalPriceByWalletIds(userId, walletIds);
  }


  Future<List<Map<String, dynamic>>> getCategorySpendingByMonth(
      String userId, int month){
    return _transactionRepository.getCategorySpendingByMonth(userId, month);
  }
}
