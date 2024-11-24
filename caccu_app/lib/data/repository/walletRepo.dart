import 'package:caccu_app/data/entity/userEntity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../entity/walletEntity.dart';

class WalletRepository{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Lấy tên ví từ Firestore
  Future<String> getWalletName(String walletId) async {
    try {
      final doc = await _db.collection('wallet').doc(walletId).get();
      if (doc.exists) {
        return doc.data()?['walletName'] ?? 'Unknown';
      }
      return 'Unknown';
    } catch (e) {
      print('Error fetching wallet name: $e');
      return 'Unknown';
    }
  }

  // Thêm mới ví
  Future<bool> addWallet(WalletEntity wallet) async {
    try {
      await _db.collection('wallet').add(wallet.toMap());
      return true; // Trả về true nếu thêm thành công
    } catch (e) {
      print('Error adding wallet: $e'); // Ghi log lỗi nếu xảy ra
      return false; // Trả về false nếu thêm thất bại
    }
  }


  // Cập nhật ví
  Future<void> updateWallet(String walletId, Map<String, dynamic> updatedData) async {
    await _db.collection('wallet').doc(walletId).update(updatedData);
  }

  // Xóa ví
  Future<bool> deleteWallet(String walletId) async {
    try {
      await _db.collection('wallet').doc(walletId).delete();
      print('Xóa wallet thành công với walletId: $walletId');
      return true; // Trả về true nếu xóa thành công
    } catch (e) {
      print('Error deleting wallet: $e');
      return false; // Trả về false nếu có lỗi
    }
  }

  //===============================================================================

  // lay walletId default
  Future<DocumentReference?> getDefaultWalletByIdByUser(String userId) async {
    DocumentReference<Map<String, dynamic>> userRef = _db.collection('users').doc(userId);
    try {
      QuerySnapshot snapshot = await _db
          .collection('wallet')
          .where('userId', isEqualTo: userRef)
          .where('walletName', isEqualTo: 'default')
          .get();

      if (snapshot.docs.isNotEmpty) {
        String walletId = snapshot.docs.first.id;
        print(_db.collection('wallet').doc(walletId));
        return _db.collection('wallet').doc(walletId);
      }
      return null; // Không tìm thấy wallet
    } catch (e) {
      print('Error getting default wallet: $e');
      return null;
    }
  }

  Future<bool> createDefaultWallet(String userId) async {
    try {
      // Chuyển userId thành DocumentReference
      DocumentReference userRef = _db.collection('users').doc(userId);

      // Tạo đối tượng WalletEntity
      WalletEntity defaultWallet = WalletEntity(
        walletName: 'default', // Tên ví mặc định
        userId: userRef, // Tham chiếu đến DocumentReference của userId
      );

      // Thêm ví mặc định vào Firestore
      await _db.collection('wallet').doc(defaultWallet.walletId).set(defaultWallet.toMap());

      print("Default wallet created successfully for userId: $userId");
      return true; // Trả về true nếu thành công
    } catch (e) {
      print("Error creating default wallet: $e");
      return false; // Trả về false nếu có lỗi
    }
  }


  Future<bool> checkDefaultWalletExists(String userId) async {
    try {
      // Chuyển userId thành DocumentReference
      DocumentReference userRef = _db.collection('users').doc(userId);

      // Truy vấn để kiểm tra ví có userId và walletName là 'default'
      QuerySnapshot querySnapshot = await _db
          .collection('wallet')
          .where('userId', isEqualTo: userRef) // Điều kiện userId
          .where('walletName', isEqualTo: 'default') // Điều kiện walletName = 'default'
          .get();

      // Nếu có ít nhất một document thì ví tồn tại
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking default wallet existence: $e");
      return false; // Trả về false nếu có lỗi
    }
  }
  //================================================================================

  // lay danh sach wallet cua userId
  Future<List<WalletEntity>> getListWalletByUserId(String userId) async {
    DocumentReference<Map<String, dynamic>> userRef = _db.collection('users').doc(userId);
    try {
      QuerySnapshot snapshot = await _db.collection('wallet')
          .where('userId', isEqualTo: userRef)
          .get();

      return snapshot.docs.map((doc) => WalletEntity.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      print('Error getting wallets by userId: $e');
      return [];
    }
  }

  // Lấy danh sách DocumentReference của walletId dựa trên userId
  Future<List<DocumentReference?>> getListWalletRefsByUserId(String userId) async {
    DocumentReference<Map<String, dynamic>> userRef = _db.collection('users').doc(userId);
    try {
      QuerySnapshot snapshot = await _db.collection('wallet')
          .where('userId', isEqualTo: userRef)
          .get();

      // Trả về danh sách DocumentReference cho từng walletId
      return snapshot.docs.map((doc) {
        return _db.collection('wallet').doc(doc.id);
      }).toList();
    } catch (e) {
      print('Error getting wallet references by userId: $e');
      return []; // Trả về danh sách rỗng nếu xảy ra lỗi
    }
  }

}