import 'package:caccu_app/presentation/Screen/Bill/bill.dart';
import 'package:caccu_app/presentation/Screen/Other/other.dart';
import 'package:caccu_app/presentation/Screen/transaction/transaction.dart';
import 'package:caccu_app/presentation/components/spendingChart.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'Home/Home.dart';
import 'addTransacion/addTransaction.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});



  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _page = 0;
  // final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _screens = [
    const Home(),
    const TransactionScreen(),
    const AddTransactionScreen(),
    const BillScreen(),
    const OtherScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: _screens[_page],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        color: Colors.red.shade400,
        animationDuration: const Duration(milliseconds: 400),
        items: const <Widget>[
          Icon(Icons.home),
          Icon(Icons.account_balance_wallet),
          Icon(Icons.add),
          Icon(Icons.event_note),
          Icon(Icons.more_horiz)
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}
