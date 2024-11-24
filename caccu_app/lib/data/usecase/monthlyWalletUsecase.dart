import 'package:cloud_firestore/cloud_firestore.dart';

import '../entity/monthlyWalletEntity.dart';
import '../repository/monthlyWalletRepo.dart';

class MonthlyWalletUseCase {
  final MonthlyWalletRepository _monthlyWalletRepository = MonthlyWalletRepository();

  // Thêm mới ví tháng
  Future<void> addMonthlyWallet(MonthlyWalletEntity monthlyWallet) async {
    await _monthlyWalletRepository.addMonthlyWallet(monthlyWallet);
  }

  // Cập nhật ví tháng
  Future<bool> updateMonthlyWallet(String monthlyWalletId, Map<String, dynamic> updatedData){
    return _monthlyWalletRepository.updateMonthlyWallet(monthlyWalletId, updatedData);
  }

  Future<bool> checkMonthlyWalletExists(DocumentReference walletId, int currentMonth) async{
    return _monthlyWalletRepository.checkMonthlyWalletExists(walletId, currentMonth);
  }

  Stream<MonthlyWalletEntity> getMonthlyWalletByIdWallet(DocumentReference walletId, int currentMonth) {
    return _monthlyWalletRepository.getMonthlyWalletByIdWallet(walletId, currentMonth);
  }

  Stream<List<MonthlyWalletEntity>> getMonthlyWalletsByWalletIds(List<String> walletIds, int month){
    return _monthlyWalletRepository.getMonthlyWalletsByWalletIds(walletIds, month);
  }

  Future<List<double>> getAvailableBalance(List<String> walletIds, int month){
    return _monthlyWalletRepository.getAvailableBalance(walletIds, month);
  }

  Future<void> deleteAllMonthlyWalletsByWalletId(String walletId){
    return _monthlyWalletRepository.deleteAllMonthlyWalletsByWalletId(walletId);
  }
}