import 'package:caccu_app/data/entity/userEntity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../entity/billEntity.dart';

class BillRepository{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Thêm mới giao dịch
  Future<void> addBill(BillEntity bill) async {
    await _db.collection('bills').add(bill.toMap());
  }

  Future<bool> addBill2(
      String userId,
      String categoryId,
      String name,
      double price,
      DateTime deadline,
      bool repeat,
      ) async {
    try {
      // Chuyển đổi các tham số thành DocumentReference
      DocumentReference userRef = _db.collection('users').doc(userId);
      DocumentReference categoryRef = _db.collection('categories').doc(categoryId);

      // Tạo dữ liệu bill
      Map<String, dynamic> billData = {
        'userId': userRef.path, // Tham chiếu đến người dùng
        'categoryId': categoryRef.path, // Tham chiếu đến danh mục
        'name': name, // Tên hóa đơn
        'price': price, // Giá trị hóa đơn
        'deadline': deadline.toIso8601String(), // Hạn chót (chuyển đổi sang chuỗi ISO)
        'repeat': repeat, // Có lặp lại hay không
      };

      // Lưu dữ liệu bill lên Firestore
      await _db.collection('bills').add(billData);
      return true; // Trả về true nếu thêm thành công
    } catch (e) {
      print("Error adding bill: $e");
      return false; // Trả về false nếu xảy ra lỗi
    }
  }


  // Cập nhật giao dịch
  Future<bool> updateBill(String billId, Map<String, dynamic> updatedData) async {
    try{
      await _db.collection('bills').doc(billId).update(updatedData);
      return true;
    }catch(e){
      return false;
    }
  }

  // Xóa giao dịch
  Future<bool> deleteBill(String billId) async {
    try{
      await _db.collection('bills').doc(billId).delete();
      return true;
    }catch(e){
      return false;
    }

  }


  Future<List<BillEntity>> getBillsByUserAndMonth(String userId, int month) async {
    DocumentReference<Map<String, dynamic>> userRef = _db.collection('users').doc(userId);
    try {
      // Determine the start and end of the month
      DateTime startOfMonth = DateTime(DateTime.now().year, month, 1);
      DateTime endOfMonth = DateTime(DateTime.now().year, month + 1, 0);

      // Query Firestore
      QuerySnapshot querySnapshot = await _db
          .collection('bills') // Assuming your collection is named 'bills'
          .where('userId', isEqualTo: userRef) // Filter by userId
          .where('deadline', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('deadline', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .get();

      // Convert Firestore data into BillEntity objects
      List<BillEntity> bills = querySnapshot.docs.map((doc) {
        return BillEntity.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return bills; // Return the list of BillEntity
    } catch (e) {
      print('Error fetching bills: $e');
      return []; // Return an empty list in case of error
    }
  }

}