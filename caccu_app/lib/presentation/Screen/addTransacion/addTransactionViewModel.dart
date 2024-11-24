import 'package:caccu_app/data/entity/categoryEntity.dart';
import 'package:caccu_app/data/entity/walletEntity.dart';
import 'package:caccu_app/data/service/LocalStorage.dart';
import 'package:caccu_app/data/usecase/walletUsecase.dart';
import 'package:caccu_app/presentation/Screen/Category/categoryViewModel.dart';
import 'package:caccu_app/presentation/Screen/Wallet/walletViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../data/usecase/transactionUsecase.dart';

class AddTransactionViewModel with ChangeNotifier{
  CategoryViewModel categoryViewModel = CategoryViewModel();
  WalletViewModel walletViewModel = WalletViewModel();
  String? userId = LocalStorageService().getUserId();

  late List<CategoryEntity> categories;

  late List<WalletEntity> wallets;

  Future<void> reload()async {
    categories = await categoryViewModel.listCategoryByUserId();
    for (var i in categories){
      print('category: ${i.name}');
    }
    wallets = await walletViewModel.fetchWalletsByUserId(userId!);
    for (var i in wallets){
      print('wallet: ${i.walletName}');
    }
  }

  Future<void> addTransaction(
      String categoryId,
      String walletId,
      double price,
      String notes,
      DateTime time) async{
    bool a = await TransactionUseCase().addTransaction2(userId!, categoryId, walletId, price, notes, time);
    if(a){
      Fluttertoast.showToast(
        msg: "Thêm giao dịch thành công",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Thêm giao dịch thất bại",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

    }

  }
}