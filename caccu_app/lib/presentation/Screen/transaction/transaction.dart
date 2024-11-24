import 'package:caccu_app/presentation/Screen/transaction/TransactionViewModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/entity/transactionEntity.dart';
import '../../../data/usecase/transactionUsecase.dart';
import 'editTransaction.dart';


class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  // late Future<void> _initializeFuture;
  // @override
  // void initState() {
  //   super.initState();
  //   // Gọi initialize() khi khởi tạo màn hình
  //   _initializeFuture = Provider.of<TransactionViewModel>(context, listen: false).getTransactionsByUserIdAndMonth(month);
  // }

  void delete(BuildContext context, String transactionId) async{

    // Gọi hàm xóa giao dịch
    bool a = await Provider.of<TransactionViewModel>(context, listen: false)
        .deleteTransaction(transactionId);
    // await Provider.of<TransactionViewModel>(context, listen: false)
    //     .fetchTransactionsByMonth(reset: true); // Làm mới danh sách giao dịch
    if(a){
      Navigator.of(context).pop(); // Đóng dialog
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Xóa giao dịch thành công!")));
      await Provider.of<TransactionViewModel>(context, listen: false)
          .fetchTransactionsByMonth(reset: true); // Làm mới danh sách giao dịch
    }
    else{
      Navigator.of(context).pop(); // Đóng dialog
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Xóa giao dịch thất bại!")));
    }
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TransactionViewModel>(
      create: (_) => TransactionViewModel(),
      child: Consumer<TransactionViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Center(
                child: const Text(
                  "DANH SÁCH GIAO DỊCH",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh), // Biểu tượng nút reload
                  onPressed: () async {
                    // Gọi hàm reload từ ViewModel
                    await Provider.of<TransactionViewModel>(context, listen: false)
                        .fetchTransactionsByMonth(reset: true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Danh sách đã được làm mới!")),
                    );
                  },
                  tooltip: 'Reload Transactions', // Tooltip hiển thị khi giữ nút
                ),
              ],

              backgroundColor: Colors.red.shade400,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: viewModel.scrollController,
                    itemCount: viewModel.transactions.length + 1, // +1 để thêm loading indicator
                    itemBuilder: (context, index) {
                      if (index < viewModel.transactions.length) {
                        final transaction = viewModel.transactions[index];
                        return _buildTransactionCard(transaction);
                      } else if (viewModel.isLoading) {
                        return const SizedBox(
                          height: 700,
                          child: Center(
                            child: CircularProgressIndicator()
                          )
                        );
                      } else if (!viewModel.hasMoreData) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 50),
                          child: const Center(
                            child: Text("không còn giao dịch."),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionCard(TransactionDetail transactionDetail) {
    final transaction = transactionDetail.transaction;
    final walletName = transactionDetail.walletName;
    final categoryName = transactionDetail.categoryName;

    final formatter = NumberFormat('#,###', 'vi_VN');
    final formattedPrice = formatter.format(transaction.price);
    final formattedTime = DateFormat('HH:mm dd/MM/yyyy').format(transaction.time!);
    final priceColor = transaction.price > 0 ? Colors.green : Colors.red;

    return GestureDetector(
      onLongPress: () {
        // Kiểm tra nếu transaction thuộc tháng hiện tại
        DateTime now = DateTime.now();
        bool isCurrentMonth = (transaction.time!.month == now.month &&
            transaction.time!.year == now.year);

        if (isCurrentMonth) {
          // Hiển thị hộp thoại xác nhận xóa
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Xác nhận xóa"),
                content: const Text("Bạn có chắc chắn muốn xóa giao dịch này?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Đóng dialog
                    },
                    child: const Text("Hủy"),
                  ),
                  TextButton(
                    onPressed: () async {
                      delete(context,transaction.transactionId!);
                    },
                    child: const Text("Xóa"),
                  ),
                ],
              );
            },
          );
        } else {
          // Hiển thị hộp thoại không thể xóa
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Không thể xóa"),
                content: const Text("Bạn không thể xóa giao dịch thuộc tháng trước."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Đóng dialog
                    },
                    child: const Text("Đóng"),
                  ),
                ],
              );
            },
          );
        }
      },
      onTap: () {
        // Kiểm tra nếu transaction thuộc tháng hiện tại
        DateTime now = DateTime.now();
        bool isCurrentMonth = (transaction.time!.month == now.month &&
        transaction.time!.year == now.year);
        if(isCurrentMonth){
          // Chuyển tiếp đến giao diện editTransaction
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditTransactionScreen(
                transaction: transaction, // Truyền transaction vào màn hình chỉnh sửa
              ),
            ),
          );
        }else{
          // Hiển thị hộp thoại không thể sưửa
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Không thể sửa giao dịch"),
                content: const Text("Bạn không thể sửa giao dịch thuộc tháng trước đó."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Đóng dialog
                    },
                    child: const Text("Đóng"),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Thời gian GD: $formattedTime", style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Tên ví: $walletName", style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text("Danh mục: $categoryName", style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text(
                "Số tiền GD: $formattedPrice VND",
                style: TextStyle(fontWeight: FontWeight.bold, color: priceColor),
              ),
              const SizedBox(height: 8),
              Text(
                "Nội dung: ${transaction.notes ?? 'Không có nội dung'}",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
