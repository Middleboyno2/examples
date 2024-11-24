import 'package:caccu_app/presentation/Screen/Bill/addBill.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'billViewModel.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  // late Future<void> _initializeFuture;
  // @override
  // void initState() {
  //   super.initState();
  //   // Gọi initialize() khi khởi tạo màn hình
  //   _initializeFuture = Provider.of<TransactionViewModel>(context, listen: false).getTransactionsByUserIdAndMonth(month);
  // }

  void delete(BuildContext context, BillViewModel billViewModel, String billId) async{

    // Gọi hàm xóa giao dịch
    bool a = await billViewModel.deleteBill(billId);
    await billViewModel
        .fetchBillsByMonth(reset: true); // Làm mới danh sách giao dịch
    if(a){
      Navigator.of(context).pop(); // Đóng dialog
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Xóa giao dịch thành công!")));
    }
    else{
      Navigator.of(context).pop(); // Đóng dialog
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Xóa giao dịch thất bại!")));
    }
  }


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BillViewModel>(
      create: (_) => BillViewModel(),
      child: Consumer<BillViewModel>(
        builder: (context, billViewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Center(
                child: const Text(
                  "DANH SÁCH HÓA ĐƠN",
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
                    // await billViewModel
                    //     .fetchTransactionsByMonth(reset: true);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text("Danh sách đã được làm mới!")),
                    // );
                  },
                  tooltip: 'Reload Bill', // Tooltip hiển thị khi giữ nút
                ),
                IconButton(
                  icon: const Icon(Icons.edit), // Biểu tượng nút reload
                  onPressed: () async {
                    // Gọi hàm reload từ ViewModel
                    // await billViewModel
                    //     .fetchTransactionsByMonth(reset: true);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text("Danh sách đã được làm mới!")),
                    // );
                  },
                  tooltip: 'Add Bill', // Tooltip hiển thị khi giữ nút
                )
              ],

              backgroundColor: Colors.red.shade400,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: billViewModel.scrollController,
                    itemCount: billViewModel.bills.length + 1, // +1 để thêm loading indicator
                    itemBuilder: (context, index) {
                      if (index < billViewModel.bills.length) {
                        final transaction = billViewModel.bills[index];
                        return _buildTransactionCard(transaction, billViewModel);
                      } else if (billViewModel.isLoading) {
                        return const SizedBox(
                            height: 700,
                            child: Center(
                                child: CircularProgressIndicator()
                            )
                        );
                      } else if (!billViewModel.hasMoreData) {
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

  Widget _buildTransactionCard(BillDetail billDetail, BillViewModel billViewModel) {
    final bill = billDetail.bill;
    final categoryName = billDetail.categoryName;

    final formatter = NumberFormat('#,###', 'vi_VN');
    final formattedPrice = formatter.format(bill.price);
    final formattedTime = DateFormat('HH:mm dd/MM/yyyy').format(bill.deadline);
    final priceColor = bill.price > 0 ? Colors.green : Colors.red;

    return GestureDetector(
      onLongPress: () {
        // Kiểm tra nếu transaction thuộc tháng hiện tại
        DateTime now = DateTime.now();
        bool isCurrentMonth = (bill.deadline.month == now.month &&
            bill.deadline.year == now.year);

        if (isCurrentMonth) {
          // Hiển thị hộp thoại xác nhận xóa
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Xác nhận xóa"),
                content: const Text("Bạn có chắc chắn muốn xóa hóa đơn này?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Đóng dialog
                    },
                    child: const Text("Hủy"),
                  ),
                  TextButton(
                    onPressed: () async {
                      delete(context, billViewModel, bill.billId!);
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
                content: const Text("Bạn không thể xóa hóa đơn thuộc tháng trước."),
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
        bool isCurrentMonth = (bill.deadline.month == now.month &&
            bill.deadline.year == now.year);
        if(isCurrentMonth){
          // Chuyển tiếp đến giao diện editTransaction
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBillScreen(
                // transaction: transaction, // Truyền transaction vào màn hình chỉnh sửa
              ),
            ),
          );
        }else{
          // Hiển thị hộp thoại không thể sưửa
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Không thể sửa hóa đơn"),
                content: const Text("Bạn không thể sửa hóa đơn thuộc tháng trước đó."),
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
              Text("Thời gian thanh toán: $formattedTime", style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Danh mục: $categoryName", style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text(
                "Số tiền thanh toán: $formattedPrice VND",
                style: TextStyle(fontWeight: FontWeight.bold, color: priceColor),
              ),
              const SizedBox(height: 8),
              Text(
                "Tên: ${bill.name ?? 'Không có nội dung'}",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                "Tự động lặp lại: ${bill.repeat ?? 'Không có nội dung'}",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}