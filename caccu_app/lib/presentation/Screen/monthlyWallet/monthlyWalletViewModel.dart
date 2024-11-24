import 'dart:ffi';

import 'package:caccu_app/data/entity/monthlyWalletEntity.dart';
import 'package:caccu_app/data/usecase/monthlyWalletUsecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MonthlyWalletViewModel with ChangeNotifier {
  // String? monthlyWalletId;
  double availableBalance = 0;
  String currency = 'vnd';
  int currentMonth = DateTime
      .now()
      .month;


  Future<bool> saveChanges(BuildContext context, MonthlyWalletEntity monthlyWallet, double newBalance) async {
    try {
      bool isUpdated = await updateMonthlyWallet(monthlyWallet, newBalance);
      if (isUpdated) {
        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật thành công!')),
        );
      } else {
        // Hiển thị thông báo lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật thất bại. Vui lòng thử lại.')),
        );
      }
      return isUpdated;
    } catch (e) {
      print('Error saving changes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra. Vui lòng thử lại sau.')),
      );
      return false;
    }
  }

  // Hàm update vi thang vào Firestore
  Future<bool> updateMonthlyWallet(MonthlyWalletEntity monthlyWallet, double available) async {

    final monthlyWal = {
      'walletId': monthlyWallet.walletId,
      'availableBalance': available,
      'currency': monthlyWallet.currency,
      'month': monthlyWallet.month,
    };
    return await MonthlyWalletUseCase().updateMonthlyWallet(monthlyWallet.monthlyWalletId!, monthlyWal);

    // TransactionUseCase().addTransaction(transaction as TransactionEntity);
  }


  void saveMonthlyWallet(DocumentReference walletId) {
    final monthlyWallet = MonthlyWalletEntity(
      walletId: walletId,
      availableBalance: availableBalance,
      currency: currency,
      month: currentMonth,
    );
    MonthlyWalletUseCase().addMonthlyWallet(monthlyWallet);
  }

  Future<void> checkMonthlyWallet(DocumentReference walletId, int month) async {
    bool check = await MonthlyWalletUseCase().checkMonthlyWalletExists(
        walletId, month);
    if (!check) {
      saveMonthlyWallet(walletId);
    }
  }



  Stream<MonthlyWalletEntity> getMonthlyWalletByUser(DocumentReference walletId, int month) {
    return MonthlyWalletUseCase().getMonthlyWalletByIdWallet(walletId, month);
  }

  Stream<List<MonthlyWalletEntity>> fetchMonthlyWalletsByWallets(List<String> walletIds) {
    return MonthlyWalletUseCase().getMonthlyWalletsByWalletIds(walletIds, currentMonth);
  }

  Future<List<double>> getAvailableBalance(List<String> walletIds, int month) async{
    return await MonthlyWalletUseCase().getAvailableBalance(walletIds, month);
  }

  Future<void> deleteAllMonthlyWalletByWalletId(String walletId) async{
    return await MonthlyWalletUseCase().deleteAllMonthlyWalletsByWalletId(walletId);
  }
}