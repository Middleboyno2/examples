// lib/data/repository/transaction_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../entity/transactionEntity.dart';


class TransactionRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Thêm mới giao dịch
  Future<void> addTransaction(TransactionEntity transaction) async {
    // cos van de sua sau
    // transaction.walletId = _db.collection('users').doc(transaction.walletId);
    await _db.collection('transactions').add(transaction.toMap());
  }
  Future<bool> addTransaction2(
    String userId,
    String categoryId,
    String walletId,
    double price,
    String notes,
    DateTime time,
  ) async {
    try {
      // Chuyển đổi các tham số thành DocumentReference
      DocumentReference userRef = _db.collection('users').doc(userId);
      DocumentReference categoryRef = _db.collection('categories').doc(categoryId);
      DocumentReference walletRef = _db.collection('wallet').doc(walletId);

      // Tạo một TransactionEntity
      TransactionEntity transaction = TransactionEntity(
        walletId: walletRef,
        price: price,
        categoryId: categoryRef,
        time: time,
        notes: notes,
        userId: userRef,
        image: '',
      );

      // Lưu transaction lên Firestore
      await _db.collection('transactions').add(transaction.toMap());
      return true; // Trả về true nếu thêm thành công
    } catch (e) {
      print("Error adding transaction: $e");
      return false; // Trả về false nếu có lỗi
    }
  }


  // Cập nhật giao dịch
  Future<bool> updateTransaction(String transactionId, Map<String, dynamic> updatedData) async {
    try{
      await _db.collection('transactions').doc(transactionId).update(updatedData);
      return true;
    }catch(e){
      print("Error update transaction: $e");
      return false;
    }

  }

  Future<bool> updateTransaction2(
      String transactionId, // ID của giao dịch cần cập nhật
      String userId,
      String categoryId,
      String walletId,
      double price,
      String notes,
      DateTime time,
      ) async {
    try {
      // Chuyển đổi các tham số thành DocumentReference
      DocumentReference userRef = _db.collection('users').doc(userId);
      DocumentReference categoryRef = _db.collection('categories').doc(categoryId);
      DocumentReference walletRef = _db.collection('wallet').doc(walletId);

      // Tạo một TransactionEntity với dữ liệu đã cập nhật
      TransactionEntity updatedTransaction = TransactionEntity(
        walletId: walletRef,
        price: price,
        categoryId: categoryRef,
        time: time,
        notes: notes,
        userId: userRef,
        image: '',
      );

      // Cập nhật transaction trên Firestore
      await _db.collection('transactions').doc(transactionId).update(updatedTransaction.toMap());
      return true; // Trả về true nếu cập nhật thành công
    } catch (e) {
      print("Error updating transaction: $e");
      return false; // Trả về false nếu có lỗi
    }
  }


  // Xóa giao dịch
  Future<bool> deleteTransaction(String transactionId) async {
    try{
      await _db.collection('transactions').doc(transactionId).delete();
      return true;
    }catch(e){
      print("Error delete transaction: $e");
      return false;
    }

  }

  // Stream để lắng nghe danh sách giao dịch theo người dùng
  Stream<List<TransactionEntity>> getTransactionsByUserStream(String userId) {
    DocumentReference<Map<String, dynamic>> userRef = _db.collection('users').doc(userId);
    return _db.collection('transactions')
        .where('userId', isEqualTo: userRef)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => TransactionEntity.fromMap(doc.data(), doc.id)).toList()
    );
  }
  // ham nay cuoi cung ko dung
  // Stream để lắng nghe danh sách giao dịch theo người dùng
  Stream<List<TransactionEntity>> getTransactions() {
    return _db.collection('transactions')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => TransactionEntity.fromMap(doc.data(), doc.id)).toList()
    );
  }


  // Hàm lấy danh sách giao dịch theo userId và month (trả về Future<List<TransactionEntity>>)
  Future<List<TransactionEntity>> getTransactionsByUserAndMonth(String userId, int month) async {
    DocumentReference<Map<String, dynamic>> userRef = _db.collection('users').doc(userId);
    try {
      // Xác định ngày bắt đầu và kết thúc của tháng
      DateTime startOfMonth = DateTime(DateTime.now().year, month, 1);
      DateTime endOfMonth = DateTime(DateTime.now().year, month + 1, 0);

      // Truy vấn Firestore
      QuerySnapshot querySnapshot = await _db
          .collection('transactions')
          .where('userId', isEqualTo: userRef) // Điều kiện userId
          .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('time', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .get();

      // Chuyển đổi dữ liệu từ Firestore sang TransactionEntity
      List<TransactionEntity> transactions = querySnapshot.docs.map((doc) {
        return TransactionEntity.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return transactions; // Trả về danh sách giao dịch
    } catch (e) {
      print('Error fetching transactions: $e');
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  //================================================================================

  Future<List<double>> getTotalPriceByWalletIds(String userId, List<String> walletIds) async {
    try {
      // Lấy tháng và năm hiện tại
      DateTime now = DateTime.now();
      DateTime startOfMonth = DateTime(now.year, now.month, 1);
      DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);

      // Tham chiếu user
      DocumentReference userRef = _db.collection('users').doc(userId);

      // Tạo map để lưu tổng tiền theo walletId
      Map<String, double> walletTotals = {
        for (var walletId in walletIds) walletId: 0.0,
      };

      // Lấy tất cả các giao dịch trong tháng hiện tại
      QuerySnapshot snapshot = await _db
          .collection('transactions')
          .where('userId', isEqualTo: userRef)
          .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('time', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .get();

      // Lặp qua tất cả các giao dịch
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Kiểm tra nếu walletId của giao dịch nằm trong danh sách walletIds
        final walletId = (data['walletId'] as DocumentReference).id;
        final price = (data['price'] ?? 0.0) as double;

        if (walletTotals.containsKey(walletId)) {
          walletTotals[walletId] = walletTotals[walletId]! + price;
        }
      }

      // Chuyển đổi Map thành List<String>, giữ thứ tự tương ứng với walletIds
      List<double> result = walletIds.map((walletId) {
        final total = walletTotals[walletId] ?? 0.0;
        return total; // Định dạng thành chuỗi với 2 chữ số thập phân
      }).toList();

      return result;
    } catch (e) {
      print("Error fetching transactions and calculating totals: $e");
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }



}
