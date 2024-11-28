
import 'package:caccu_app/data/service/LocalStorage.dart';
import 'package:caccu_app/presentation/Screen/Wallet/Wallet.dart';
import 'package:caccu_app/presentation/components/spendingChart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../../data/entity/notificationEntity.dart';
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
  String? userName = LocalStorageService().getUserName();
  List<NotificationEntity> notifications = []; // List to store notifications
  Set<String> readNotificationIds = {}; // To track read notifications

  @override
  void initState() {
    super.initState();
    // Gọi initialize() khi khởi tạo màn hình
    _initializeFuture = Provider.of<HomeViewModel>(context, listen: false).initialize();
    // Provider.of<HomeViewModel>(context, listen: false).testGetMonthlyWalletsByWalletIds();
    _initTran = Provider.of<HomeViewModel>(context, listen: false).loadTransactions(DateTime.now().month);
    _loadNotifications();

  }

  Future<void> _loadNotifications() async {
    // Replace this with your actual logic to fetch notifications
    notifications = await Provider.of<HomeViewModel>(context, listen: false)
        .getNotificationByUserId(); // Implement this in HomeViewModel
    setState(() {}); // Update UI with fetched notifications
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
          return Scaffold(
            appBar: AppBar(
              title: Text('Xin chào, $userName'),
              // backgroundColor: Colors.red.shade300,
              actions: [
                PopupMenuButton(
                  icon: Icon(Icons.notifications_active_outlined),
                  itemBuilder: (BuildContext context) {
                    return notifications.map((notification) {
                      return PopupMenuItem(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: GestureDetector(
                          onTap: () async {
                            // Update status in Firestore via ViewModel
                            await Provider.of<HomeViewModel>(context, listen: false)
                                .setStatusNotification(notification.notificationId!, true);
                            // Reload notifications after status update
                            await _loadNotifications();
                            initState;
                          },
                          child: Container(
                            color: notification.status ? Colors.red.shade100 : Colors.grey[300],
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    notification.time!.toLocal().toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Text(
                                  notification.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black45, fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(notification.content),
                                const SizedBox(height: 4),

                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            body:SingleChildScrollView(
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
            ),
          );
        }
      },
    );

  }
}
