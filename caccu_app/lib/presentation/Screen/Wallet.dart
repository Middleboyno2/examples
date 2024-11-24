import 'package:caccu_app/presentation/Screen/Home/HomeViewModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Wallet/addWallet.dart';
import 'Wallet/editWallet.dart';



class WalletBottomSheet extends StatelessWidget {
  final Stream<List<Map<String, dynamic>>> monthlyWallet;
  final HomeViewModel homeViewModel;


  const WalletBottomSheet({super.key, required this.monthlyWallet, required this.homeViewModel});

  String formatCurrency(int available, int totalAmount) {
    final formatter = NumberFormat("#,##0", "vi_VN"); // "vi_VN" là mã ngôn ngữ Tiếng Việt
    int value = available - totalAmount;
    return formatter.format(value);
  }

  String sumAvailable(List<double> availableBalance){
    double sum = 0;
    final formatter = NumberFormat("#,##0", "vi_VN");
    for (var balance in availableBalance){
      sum += balance;
    }
    String a = formatter.format(sum);
    return a.toString();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: FutureBuilder(
            future: homeViewModel.reloadListWalletAndListAvailable(), // Nạp dữ liệu trước
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ví Của Tôi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.refresh, color: Colors.white),
                              onPressed: () {
                                homeViewModel.reloadListWalletAndListAvailable();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.add_box_outlined, color: Colors.white),
                              onPressed: () {
                                // Thêm hành động cho nút sửa
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AddWalletScreen()
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildTotalCard(),
                    SizedBox(height: 16),
                    const Text(
                      'Danh sách ví',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: homeViewModel.monthlyWalletStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text('No wallets available');
                        } else {
                          final dataList = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            // physics: const NeverScrollableScrollPhysics(),
                            itemCount: dataList.length,
                            itemBuilder: (context, index) {
                              final wallet = dataList[index];
                              return _buildWalletCard(context, wallet);
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTotalCard() {
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(Icons.public, color: Colors.white),
        ),
        title: Text(
          'Tổng cộng',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          '${sumAvailable(homeViewModel.availableBalances)} vnđ',
          style: TextStyle(color: Colors.white),
        ),
        trailing: Icon(Icons.check_circle, color: Colors.blue),
      ),
    );
  }

  Widget _buildWalletCard(BuildContext context,Map<String, dynamic> monthlyWallet) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded( // Đặt ListTile trong Expanded để tự động điều chỉnh kích thước
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.account_balance_wallet, color: Colors.white),
                ),
                title: Text(
                  '${monthlyWallet['walletName']}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                subtitle: Text(
                  'số dư: ${formatCurrency(monthlyWallet['availableBalance'].toInt(),monthlyWallet['totalAmount'].toInt())} vnđ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    // Thêm hành động cho nút sửa
                    try {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditMonthlyWalletScreen(
                            monthlyWallet: monthlyWallet['monthlyWallets'], // Thay thế bằng đối tượng monthlyWallet của bạn
                          ),
                        ),
                      );
                    } catch (e, s) {
                      print(s);
                    }

                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    // Thêm hành động cho nút xóa
                    HomeViewModel().deleteItemWithLoading(context, monthlyWallet['monthlyWallets']);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Để mở BottomSheet này từ một Widget khác, bạn sử dụng:
void showWalletBottomSheet(BuildContext context, Stream<List<Map<String, dynamic>>> monthlyWalletStream, HomeViewModel homeViewModel) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black, // Màu nền của BottomSheet
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => WalletBottomSheet(monthlyWallet: monthlyWalletStream, homeViewModel: homeViewModel),
  );
}
