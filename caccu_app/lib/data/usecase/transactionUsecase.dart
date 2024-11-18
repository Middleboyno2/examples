// lib/services/transaction_service.dart
import '../entity/transactionEntity.dart';
import '../repository/transactionRepo.dart';

class TransactionUseCase {
  final TransactionRepository _transactionRepository = TransactionRepository();

  // Thêm giao dịch mới
  Future<void> addTransaction(TransactionEntity transaction) async {
    await _transactionRepository.addTransaction(transaction);
  }

  // Cập nhật giao dịch
  Future<void> updateTransaction(String transactionId, Map<String, dynamic> updatedData) async {
    await _transactionRepository.updateTransaction(transactionId, updatedData);
  }

  // Xóa giao dịch
  Future<void> deleteTransaction(String transactionId) async {
    await _transactionRepository.deleteTransaction(transactionId);
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
}
