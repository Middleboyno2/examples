import 'dart:async';
import 'dart:async';

import 'package:caccu_app/data/entity/transactionEntity.dart';
import 'package:caccu_app/data/service/LocalStorage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../data/usecase/transactionUsecase.dart';
import '../categoryViewModel.dart';
import '../walletViewModel.dart';

class TransactionDetail {
  final TransactionEntity transaction;
  final String walletName;
  final String categoryName;

  TransactionDetail({
    required this.transaction,
    required this.walletName,
    required this.categoryName,
  });
}


class TransactionViewModel with ChangeNotifier {

  CategoryViewModel categoryViewModel = CategoryViewModel();
  WalletViewModel walletViewModel = WalletViewModel();
  // ================================================================================
  String? userIdString = LocalStorageService().getUserId();
  // Các thông tin giao dịch
  String? categoryId;
  String? image = "";
  String? note;
  double? price;
  DateTime time = DateTime.now();
  DocumentReference? userId;
  DocumentReference? walletId;

  //===================================================================================

  final List<TransactionDetail> _transactions = [];
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;
  bool hasMoreData = true; // Flag kiểm tra còn dữ liệu để tải không

  List<TransactionDetail> get transactions => _transactions;

  TransactionViewModel() {
    scrollController.addListener(_onScroll);
    fetchTransactionsByMonth();
  }
  //===================================================================================
  Future<void> fetchTransactionsByMonth({bool reset = false}) async {
    if (isLoading || !hasMoreData) return;

    isLoading = true;
    notifyListeners();
    if (reset) {
      _transactions.clear();
      currentMonth = DateTime.now().month;
      currentYear = DateTime.now().year;
      hasMoreData = true;
    }

    // Lấy dữ liệu từ Firestore thông qua UseCase
    List<TransactionEntity> newTransactions = await getTransactionsByUserAndMonth(userIdString!, currentMonth);

    if (newTransactions.isEmpty) {
      // Nếu không có giao dịch trong tháng, giảm tháng và tiếp tục
      hasMoreData = false;
    } else {
      // Lấy tên ví và tên danh mục cho mỗi giao dịch
      for (var transaction in newTransactions) {
        final walletName = await _getWalletName(transaction.walletId.id);
        final categoryName = await _getCategoryName(transaction.categoryId.id);
        print('walletName: $walletName');
        print('categoryName: $categoryName');
        _transactions.add(
          TransactionDetail(
            transaction: transaction,
            walletName: walletName,
            categoryName: categoryName,
          ),
        );
      }
      // Sắp xếp danh sách theo ngày (gần nhất -> xa nhất)
      _transactions.sort((a, b) {
        return b.transaction.time!.compareTo(a.transaction.time!);
      });
    }

    // Chuyển sang tháng trước
    currentMonth--;
    if (currentMonth == 0) {
      currentMonth = 12;
      currentYear--;
    }

    isLoading = false;
    notifyListeners();
  }

  void _onScroll() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && hasMoreData) {
      fetchTransactionsByMonth();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }


  //===================================================================================

  Stream<List<TransactionEntity>> getTransByUser(String userId) {
    return TransactionUseCase().getTransactionsByUser(userId);
  }
  Stream<List<TransactionEntity>> getTrans() {
    return TransactionUseCase().getTransactions();
  }

  // Hàm lưu giao dịch vào Firestore
  Future<void> saveTransaction() async {

    final transaction = {
      'categoryId': categoryId,
      'image': image,
      'note': note,
      'price': price,
      'time': Timestamp.fromDate(time),
      'userId': '$userId',
      'walletId': '$walletId',
    };

    TransactionUseCase().addTransaction(transaction as TransactionEntity);
  }
  // daành cho HomeView
  Future<List<TransactionEntity>> getTransactionsByUserAndMonth(String userId, int month) {
    return TransactionUseCase().getTransactionsByUserAndMonth(userId, month);
  }
  // daành cho HomeView
  Future<List<TransactionEntity>> getTransactionsByUserAndMonthSort(String userId, int month) async{
    List<TransactionEntity> list = await TransactionUseCase().getTransactionsByUserAndMonth(userId, month);
    // Sắp xếp danh sách theo ngày (gần nhất -> xa nhất)
    list.sort((a, b) {
      return b.time!.compareTo(a.time!);
    });
    return list;
  }

  // Lấy tên ví từ Firestore
  Future<String> _getWalletName(String walletId) async {
    return walletViewModel.getWalletName(walletId);
  }

  // Lấy tên danh mục từ Firestore
  Future<String> _getCategoryName(String categoryId) async {
    return categoryViewModel.getCategoryName(categoryId);
  }


  Future<bool> deleteTransaction(String transactionId) async{
    return await TransactionUseCase().deleteTransaction(transactionId);
  }

  //====================================================================================
  Future<void> updateTransaction(
      String transactionId,
      String categoryId,
      String walletId,
      double price,
      String notes,
      DateTime time) async{
    bool a = await TransactionUseCase().updateTransaction2(transactionId, userIdString!, categoryId, walletId, price, notes, time);
    if(a){
      Fluttertoast.showToast(
        msg: "Update giao dịch thành công",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Update giao dịch thất bại",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

    }

  }

  Future<List<double>> getTotalPriceByWalletIds(String userId, List<String> walletIds){
    return TransactionUseCase().getTotalPriceByWalletIds(userId, walletIds);
  }

}
