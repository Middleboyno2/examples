import 'package:caccu_app/data/entity/transactionEntity.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/usecase/transactionUsecase.dart';

class TransactionViewModel with ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  // Các thông tin giao dịch
  String? categoryId;
  String? image = "";
  String? note;
  double? price;
  DateTime time = DateTime.now();
  String? userId;
  String? walletId;

  // Hàm validate và lưu dữ liệu
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Hàm lưu giao dịch vào Firestore
  Future<void> saveTransaction() async {
    final transaction = {
      'categoryId': categoryId,
      'image': image,
      'note': note,
      'price': price,
      'time': Timestamp.fromDate(time),
      'userId': '/users/$userId',
      'walletId': '/wallet/$walletId',
    };

    TransactionUseCase().addTransaction(transaction as TransactionEntity);
  }
}
