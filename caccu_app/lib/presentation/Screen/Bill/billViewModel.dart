import 'package:caccu_app/data/service/LocalStorage.dart';
import 'package:caccu_app/data/usecase/billUsecase.dart';
import 'package:caccu_app/presentation/Screen/Category/categoryViewModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../data/entity/billEntity.dart';
import '../../../data/entity/categoryEntity.dart';
import '../Wallet/walletViewModel.dart';

class BillDetail {
  final BillEntity bill;
  final String categoryName;

  BillDetail({
    required this.bill,
    required this.categoryName,
  });
}

class BillViewModel with ChangeNotifier{
  CategoryViewModel categoryViewModel = CategoryViewModel();
  late List<CategoryEntity> categories;
  String? userId = LocalStorageService().getUserId();


  //===================================================================================

  final List<BillDetail> _bills = [];
  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;
  bool hasMoreData = true; // Flag kiểm tra còn dữ liệu để tải không

  List<BillDetail> get bills => _bills;

  BillViewModel() {
    scrollController.addListener(_onScroll);
    fetchBillsByMonth();
  }
  //===================================================================================
  Future<void> fetchBillsByMonth({bool reset = false}) async {
    if (isLoading || !hasMoreData) return;

    isLoading = true;
    notifyListeners();
    if (reset) {
      _bills.clear();
      currentMonth = DateTime.now().month;
      currentYear = DateTime.now().year;
      hasMoreData = true;
    }

    // Lấy dữ liệu từ Firestore thông qua UseCase
    List<BillEntity> newBills = await BillUseCase().getBillsByUserAndMonth(userId!, currentMonth);

    if (newBills.isEmpty) {
      // Nếu không có giao dịch trong tháng, giảm tháng và tiếp tục
      hasMoreData = false;
    } else {
      // Lấy tên ví và tên danh mục cho mỗi giao dịch
      for (var bill in newBills) {
        // final walletName = await _getWalletName(transaction.walletId.id);
        final categoryName = await _getCategoryName(bill.categoryId.id);
        // print('walletName: $walletName');
        print('categoryName: $categoryName');
        _bills.add(
          BillDetail(
            bill: bill,
            categoryName: categoryName,
          ),
        );
      }
      // Sắp xếp danh sách theo ngày (gần nhất -> xa nhất)
      _bills.sort((a, b) {
        return b.bill.deadline.compareTo(a.bill.deadline);
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
      fetchBillsByMonth();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  // Lấy tên danh mục từ Firestore
  Future<String> _getCategoryName(String categoryId) async {
    return categoryViewModel.getCategoryName(categoryId);
  }

  //=======================================================================================





  Future<void> reload()async {
    categories = await categoryViewModel.listCategoryByUserId();
    for (var i in categories){
      print('category: ${i.name}');
    }
  }
  Future<void> addBill2(
      String categoryId,
      String name,
      double price,
      DateTime deadline,
      bool repeat) async{
    bool a = await BillUseCase().addBill2(userId!, categoryId, name, price, deadline, repeat);
    if(a){
      Fluttertoast.showToast(
        msg: "Thêm hóa đơn thành công",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Thêm hóa đơn thất bại",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

    }
  }

  //===============================================================================
  Future<bool> deleteBill(String billId) async{
    return await BillUseCase().deleteBill(billId);
  }
  Future<bool> updateBill(
      String billId, // ID of the bill to update
      String categoryId,
      String name,
      double price,
      DateTime deadline,
      bool repeat,
      ) async{
    return await BillUseCase().
    updateBill2(billId, userId!, categoryId, name, price, deadline, repeat);

  }


}