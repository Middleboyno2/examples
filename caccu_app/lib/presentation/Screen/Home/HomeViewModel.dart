import 'dart:async';
import 'dart:ffi';

import 'package:caccu_app/data/entity/monthlyWalletEntity.dart';
import 'package:caccu_app/data/service/LocalStorage.dart';
import 'package:caccu_app/data/usecase/noticationUseCase.dart';
import 'package:caccu_app/presentation/Screen/Category/categoryViewModel.dart';
import 'package:caccu_app/presentation/Screen/Summary/Summary.dart';
import 'package:caccu_app/presentation/Screen/monthlyWallet/monthlyWalletViewModel.dart';
import 'package:caccu_app/presentation/Screen/transaction/TransactionViewModel.dart';
import 'package:caccu_app/presentation/Screen/Wallet/walletViewModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../data/entity/categoryEntity.dart';
import '../../../data/entity/notificationEntity.dart';
import '../../../data/entity/transactionEntity.dart';
import '../../../data/entity/walletEntity.dart';
import '../../../data/usecase/walletUsecase.dart';
import '../../components/categorySpending.dart';
import '../Summary/monthlySummary.dart';

class HomeViewModel with ChangeNotifier{
  WalletViewModel walletViewModel = WalletViewModel();
  MonthlyWalletViewModel monthlyWalletViewModel = MonthlyWalletViewModel();
  TransactionViewModel transactionViewModel = TransactionViewModel();
  CategoryViewModel categoryViewModel = CategoryViewModel();
  // lay userId
  String? userId = LocalStorageService().getUserId();
  // lay wallet mac dinh
  DocumentReference? walletIdDefault;
  // lay list walletId dang documentReference
  late List<DocumentReference?> walletIdRefs;
  //lay thang hien tai
  int currentMonth = DateTime.now().month;
  // thong tin vi thang hien tai
  MonthlyWalletEntity? currentMonthlyWallet; // Thay đổi thành kiểu nullable

  // Biến lưu trữ danh sách giao dịch
  List<TransactionEntity> transactions = [];

  // Declare the external categorySpending list
  late List<Map<String, dynamic>> categorySpending;

  // --------------------------------------------------------------------------------

  // list wallet
  late List<WalletEntity> wallets;

  late List<double> availableBalances;

  late List<String> walletIds;

  late List<String> walletNames;

  late List<double> totalAmounts;

  late List<double> balances;

  //----------------------------------------------------------------------------------

  final StreamController<List<Map<String, dynamic>>> _monthlyWalletStreamController = StreamController.broadcast();

  Stream<List<Map<String, dynamic>>> get monthlyWalletStream => _monthlyWalletStreamController.stream;

  //-----------------------------------------------------------------------------------

  Future<void> reloadListWalletAndListAvailable() async {
    // Lấy dữ liệu từ ViewModel
    wallets = await walletViewModel.fetchWalletsByUserId(userId!);
    // check list wallets tra ve
      for (var wallet in wallets) {
        print(wallet);
      }
    walletIds = wallets.map((wallet) => wallet.walletId).where((id) => id != null).cast<String>().toList();
    // check list walletIds tra ve
    for (var walletId in walletIds) {
      print(walletId);
    }
    walletNames = wallets.map((wallet) => wallet.walletName).where((id) => id != null).cast<String>().toList();
    // check list walletName tra ve
    for (var walletName in walletNames) {
      print(walletName);
    }
    availableBalances = await monthlyWalletViewModel.getAvailableBalance(walletIds, currentMonth);
    // check list available tra ve
    for (var available in availableBalances) {
      print(available);
    }

    totalAmounts = await transactionViewModel.getTotalPriceByWalletIds(userId!, walletIds);
    for (var totalAmount in totalAmounts) {
      print('totalAmount: $totalAmount');
    }


    // lay list walletId dang DocumentReference
    walletIdRefs = await walletViewModel.getListWalletRefsByUserId(userId!);
    for (var walletIdRef in walletIdRefs) {
      monthlyWalletViewModel.checkMonthlyWallet(walletIdRef!, currentMonth);
      print(walletIdRef);
    }
    // Phát dữ liệu mới lên Stream
    _updateStream();
  }

  void _updateStream() async {
    List<MonthlyWalletEntity> monthlyWallets = await monthlyWalletViewModel.fetchMonthlyWalletsByWallets(walletIds).first;

    int minLength = walletNames.length < monthlyWallets.length ? walletNames.length : monthlyWallets.length;
    print('minLength: ${walletNames.length}');
    print('minLength: ${monthlyWallets.length}');
    List<Map<String, dynamic>> combinedList = [];
    for (int i = 0; i < minLength; i++) {
      combinedList.add({
        'walletName': walletNames[i],
        'availableBalance': availableBalances[i],
        'monthlyWallets': monthlyWallets[i],
        'totalAmount': totalAmounts[i]
      });
    }

    // Phát dữ liệu mới
    _monthlyWalletStreamController.add(combinedList);
  }


  //----------------------------------------------------------------------------------

  // ham nay duoc su dung khi tab Home duoc tro toi
  // lay thong tin vi default va luu no lai thoi
  Future<void> initialize(BuildContext context) async {
    //================================================================
    if(LocalStorageService().getCount() == 0){
      // Kiểm tra xem ngày đầu tháng không
      if (DateTime.now().day == 1 ) {
        List<Map<String, dynamic>> summary = await Summary();
        Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SummaryScreen(summary: summary)
            ));
        LocalStorageService().saveCount(1);
      }
    }
    else{
      if (DateTime.now().day != 1) {
        LocalStorageService().saveCount(0);
      }
    }
    //===============================================================


    userId = LocalStorageService().getUserId();
    if (userId != null) {
      walletIdDefault = await walletViewModel.getDefaultWalletByIdUser(userId!);
      print('Wallet ID Default: $walletIdDefault');

      await categoryViewModel.syncDefaultCategories();
      // test nhờ
      // await categoryViewModel.fetchUserCategories();
      if (walletIdDefault != null) {
        // Kiểm tra và tạo monthly wallet nếu cần thiết
        await monthlyWalletViewModel.checkMonthlyWallet(walletIdDefault!, currentMonth);

        // Lấy dữ liệu đầu tiên từ Stream và lưu trữ vào biến
        currentMonthlyWallet = await monthlyWalletViewModel
            .getMonthlyWalletByUser(walletIdDefault!, currentMonth)
            .first;
        print('Current Monthly Wallet: $currentMonthlyWallet');

        notifyListeners(); // Gọi để cập nhật UI sau khi có dữ liệu
      }

      await updateNotificationsForUser();
      //===============================================================


      notifyListeners();
    }
  }

  //--------------------------------------------------------------------------------

  // Hàm lưu và làm mới dữ liệu giao dịch và lưu vào `transactions`
  Future<void> loadTransactions( int month) async {
    try {
      transactions = await transactionViewModel.getTransactionsByUserAndMonthSort(userId!, month);
      for(var tran in transactions){
        print('time: ${tran.time}');
        print('price: ${tran.price}');
      }
      notifyListeners(); // Thông báo để cập nhật giao diện
    } catch (e) {
      print("Error loading transactions: $e");
      transactions = [];
      notifyListeners(); // Thông báo để cập nhật giao diện trong trường hợp lỗi
    }
  }

  //-----------------------------------------------------------------------------------

  // lay thong tin vi default
  MonthlyWalletEntity? getMonthlyWalletDefault() {
    if (currentMonthlyWallet == null) {
      throw Exception('currentMonthlyWallet chưa được khởi tạo');
    }
    return currentMonthlyWallet!;

  }

  //---------------------------------------------------------------------------------


  // lay walletName va availableBalance tuong ung
  Stream<List<Map<String, dynamic>>> getAllMonthlyWallet() async* {

    // lay list walletId dang DocumentReference
    walletIdRefs = await walletViewModel.getListWalletRefsByUserId(userId!);
    // check neu vi nao chua co vi thang hien tai thi tao moi 1 vi thang tuong ung
    for (var wal in walletIdRefs) {
       monthlyWalletViewModel.checkMonthlyWallet(wal!, currentMonth);
    }

    await reloadListWalletAndListAvailable();

    // Lắng nghe stream danh sách monthly wallet
    yield* monthlyWalletViewModel.fetchMonthlyWalletsByWallets(walletIds).map((
        monthlyWallets) {

      // Kiểm tra độ dài để đồng bộ danh sách
      int minLength = walletNames.length < monthlyWallets.length
          ? walletNames.length
          : monthlyWallets.length;

      // Tạo danh sách kết hợp
      List<Map<String, dynamic>> combinedList = [];
      for (int i = 0; i < minLength; i++) {
        combinedList.add({
          'walletName': walletNames[i],
          'availableBalance': availableBalances[i],
          'monthlyWallets': monthlyWallets[i],
        });
      }
      notifyListeners();
      return combinedList;
    });
  }

  Future<bool> deleteItemWithLoading(BuildContext context, MonthlyWalletEntity monthlyWallet) async {
    String walletId = monthlyWallet.walletId.id;
    bool confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa ví $walletId này?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Hủy
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Đồng ý
              },
              child: const Text('Đồng ý'),
            ),
          ],
        );
      },
    ) ?? false;

    if (!confirmed) return false;

    // Hiển thị CircularProgressIndicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Thực hiện xóa
      bool result = await walletViewModel.deleteWallet(walletId);
      await monthlyWalletViewModel.deleteAllMonthlyWalletByWalletId(walletId);

      // Gọi reload để cập nhật giao diện
      reloadListWalletAndListAvailable();

      // Đóng CircularProgressIndicator
      Navigator.of(context).pop();

      // Thông báo kết quả
      if (result) {
        Fluttertoast.showToast(
          msg: "Xóa thành công!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return true;
      } else {
        Fluttertoast.showToast(
          msg: "Xóa thất bại!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: "Có lỗi xảy ra: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }


  Future<bool> addWallet(BuildContext context, String walletName) async {
    try {
      bool result = await walletViewModel.saveWallet(userId!, walletName);

      if (result) {
        await reloadListWalletAndListAvailable();
        // check neu vi nao chua co vi thang hien tai thi tao moi 1 vi thang tuong ung

        Fluttertoast.showToast(
          msg: "Thêm ví thành công",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.pop(context);
        return true;
      } else {
        Fluttertoast.showToast(
          msg: "Thêm ví thất bại",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Lỗi khi thêm ví: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }
  //=============================notification======================================

  Future<List<NotificationEntity>> getNotificationByUserId(){
    return NotificationUseCase().getNotificationByUserId(userId!, true);
  }
  Future<void> setStatusNotification(String notificationId, bool newStatus){
    return NotificationUseCase().setStatusNotification(notificationId, newStatus);
  }

  Future<void> updateNotificationsForUser() async {

    await NotificationUseCase().updateNotificationsForUser(userId!);
  }


  //==============================================================================



  Future<void> loadCategorySpending(int month) async {
    try {
      // Fetch category spending
      List<Map<String, dynamic>> spendingData = await transactionViewModel.getCategorySpendingByMonth(month);
      double totalAllPrice = 0;
      for (var spending in spendingData){
        totalAllPrice += spending['totalPrice'];
      }
      // Extract category IDs
      List<String> categoryIds = spendingData.map((data) => data['categoryId'] as String).toList();

      late List<CategoryEntity> categories ;
      if(categoryIds.isNotEmpty){
        // Fetch categories
        categories = await categoryViewModel.getCategoriesByIds(categoryIds);
      }


      // Combine spending data with category data into categorySpending
      categorySpending = [];
      for (var spending in spendingData) {
        var category = categories.firstWhere((cat) => cat.categoryId == spending['categoryId']);
        categorySpending.add({
          'categoryId': spending['categoryId'],
          'categoryName': category.name,
          'totalPrice': spending['totalPrice'],
          'totalAllPrice' : totalAllPrice,
          'icon': category.icon,

        });

        categorySpending.sort((a, b) => b['totalPrice'].compareTo(a['totalPrice']));
      }

      // Notify listeners or perform UI updates if needed
      print("Category spending data loaded successfully.");
    } catch (e) {
      print("Error loading category spending data: $e");
    }
  }

  Future<List<Map<String, dynamic>>> Summary() async{
    //transactions
    List<TransactionEntity> transacs = await transactionViewModel.getTransactionsByUserAndMonthSort(userId!, DateTime.now().month - 1);


    List<Map<String, dynamic>> spendingData = await transactionViewModel.getCategorySpendingByMonth(DateTime.now().month - 1);

    double totalAllPrice = 0;
    for (var spending in spendingData){
      totalAllPrice += spending['totalPrice'];
    }
    // Extract category IDs
    List<String> categoryIds = spendingData.map((data) => data['categoryId'] as String).toList();

    late List<CategoryEntity> categories ;
    if(categoryIds.isNotEmpty){
      // Fetch categories
      categories = await categoryViewModel.getCategoriesByIds(categoryIds);
    }


    // Combine spending data with category data into categorySpending
    List<Map<String, dynamic>> summary = [];
    for (var spending in spendingData) {
      var category = categories.firstWhere((cat) => cat.categoryId == spending['categoryId']);
      summary.add({
        // 'categoryId': spending['categoryId'],
        'categoryName': category.name,
        'totalPrice': spending['totalPrice'],
        'totalAllPrice' : totalAllPrice,
        'icon': category.icon,
        'transactions': transacs,
        'limit': category.limit

      });
      summary.sort((a, b) => b['totalPrice'].compareTo(a['totalPrice']));
    }
    return summary;

  }


}