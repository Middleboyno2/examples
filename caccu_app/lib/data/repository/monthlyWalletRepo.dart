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
  Future<bool> updateMonthlyWallet(String monthlyWalletId, Map<String, dynamic> updatedData) async {
    try {
      await _db.collection('monthly_wallet').doc(monthlyWalletId).update(updatedData);
      return true; // Cập nhật thành công
    } catch (e) {
      print('Error updating monthly wallet: $e');
      return false; // Cập nhật thất bại
    }
  }

  // Xóa ví tháng
  Future<void> deleteMonthlyWallet(String monthlyWalletId) async {
    await _db.collection('monthly_wallet').doc(monthlyWalletId).delete();
  }

  // check xem tại walletId và month tương ứng co ton tai khong
  Future<bool> checkMonthlyWalletExists(DocumentReference walletId, int currentMonth) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('monthly_wallet')
          .where('walletId', isEqualTo: walletId)
          .where('month', isEqualTo: currentMonth)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking monthly wallet: $e');
      return false;
    }
  }


  // Stream để lắng nghe monthly wallet theo walletId và tháng hiện tại
  Stream<MonthlyWalletEntity> getMonthlyWalletByIdWallet(DocumentReference walletId, int currentMonth) {
    // DocumentReference<Map<String, dynamic>> walletRef = _db.collection('wallet').doc(walletId);
    // print('trong monthlyWalletRepo: $walletId');
    // print('trong monthlyWalletRepo: $currentMonth');
    return _db.collection('monthly_wallet')
        .where('walletId', isEqualTo: walletId)
        .where('month', isEqualTo: currentMonth)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return MonthlyWalletEntity.fromMap(snapshot.docs.first.data(), snapshot.docs.first.id);
      } else {
        throw Exception('No monthly wallet found for this user and month.');
      }
    });

  }

  // trả ve list monthlywallet tuongw ung
  Stream<List<MonthlyWalletEntity>> getMonthlyWalletsByWalletIds(List<String> walletIds, int month) {
    try {
      List<DocumentReference<Map<String, dynamic>>> walletRefs = walletIds
          .map((walletId) => _db.collection('wallet').doc(walletId))
          .toList();

      return _db.collection('monthly_wallet')
          .where('walletId', whereIn: walletRefs)
          .where('month', isEqualTo: month)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          // Tạo một map để dễ dàng sắp xếp
          Map<String, MonthlyWalletEntity> walletMap = {
            for (var doc in snapshot.docs)
              doc.data()['walletId'].id: MonthlyWalletEntity.fromMap(doc.data() as Map<String, dynamic>, doc.id)
          };

          // Sắp xếp lại danh sách theo thứ tự walletIds
          return walletIds.map((id) => walletMap[id]).whereType<MonthlyWalletEntity>().toList();
        } else {
          return []; // Trả về danh sách rỗng nếu không tìm thấy kết quả
        }
      });
    } catch (e) {
      print('Error getting monthly wallets: $e');
      return const Stream.empty(); // Trả về một Stream rỗng trong trường hợp có lỗi
    }
  }



  Future<List<double>> getAvailableBalance(List<String> walletIds, int month) async {
    try {
      List<DocumentReference<Map<String, dynamic>>> walletRefs = walletIds.map(
              (id) => _db.collection('wallet').doc(id)
      ).toList();

      QuerySnapshot snapshot = await _db.collection('monthly_wallet')
          .where('walletId', whereIn: walletRefs)
          .where('month', isEqualTo: month)
          .get();

      // Kết hợp walletId với availableBalance
      Map<String, double> balanceMap = {
        for (var doc in snapshot.docs)
          if ((doc.data() as Map<String, dynamic>)['walletId'] != null)
            ((doc.data() as Map<String, dynamic>)['walletId'] as DocumentReference).id:
            MonthlyWalletEntity.fromMap(
                doc.data() as Map<String, dynamic>, doc.id
            ).availableBalance
      };

      // Trả về danh sách theo thứ tự walletIds
      return walletIds.map((id) => balanceMap[id] ?? 0.0).toList();
    } catch (e) {
      print('Error getting available balances: $e');
      return List.filled(walletIds.length, 0.0); // Trả về danh sách mặc định nếu có lỗi
    }
  }


  // ham xoa het ban ghi tai walletId
  Future<void> deleteAllMonthlyWalletsByWalletId(String walletId) async {
    try {
      // Truy vấn tất cả các monthly_wallet có walletId tương ứng
      QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('monthly_wallet')
          .where('walletId', isEqualTo: _db.collection('wallet').doc(walletId))
          .get();

      // Duyệt qua các document và xóa từng document
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      print('Xóa tất cả MonthlyWallet thành công với walletId: $walletId');
    } catch (e) {
      print('Error deleting MonthlyWallets by walletId: $e');
      throw Exception('Không thể xóa MonthlyWallets cho walletId: $walletId');
    }
  }




}