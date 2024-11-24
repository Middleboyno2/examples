
import 'package:caccu_app/presentation/Screen/Wallet/Wallet.dart';
import 'package:caccu_app/presentation/Screen/Category/categoryViewModel.dart';
import 'package:caccu_app/presentation/components/lineChart.dart';
import 'package:caccu_app/presentation/components/spendingChart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../components/BoxWallet.dart';

import 'HomeViewModel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<void> _initializeFuture;
  late Future<void> _initTran;

  @override
  void initState() {
    super.initState();
    // Gọi initialize() khi khởi tạo màn hình
    _initializeFuture = Provider.of<HomeViewModel>(context, listen: false).initialize();
    // Provider.of<HomeViewModel>(context, listen: false).testGetMonthlyWalletsByWalletIds();
    _initTran = Provider.of<HomeViewModel>(context, listen: false).loadTransactions(DateTime.now().month);

    // Provider.of<CategoryViewModel>(context, listen: false).syncDefaultCategories();
  }
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _initializeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Hiển thị khi đang tải
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Hiển thị khi có lỗi
        } else {
          return SingleChildScrollView(
            child: Consumer<HomeViewModel>(
              builder: (context, homeViewModel, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    WalletComponent(
                      monthlyWallet: homeViewModel.getMonthlyWalletDefault(),
                      onViewAllPressed: () {
                        showWalletBottomSheet(context, homeViewModel.getAllMonthlyWallet(), homeViewModel);
                      },
                    ),
                    FutureBuilder(
                      future: _initTran,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          return SizedBox(
                            height: 600,
                            child: SpendingChart(transactions: homeViewModel.transactions)
                          );
                        }
                      }
                    ),
                  ],
                );
              },
            ),
          );
        }
      },
    );

  }
}
