import 'package:caccu_app/presentation/Screen/transaction/transaction.dart';
import 'package:caccu_app/presentation/components/spendingChart.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'Home/Home.dart';
import 'addTransaction.dart';

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
    addTransactionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _screens[_page],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.white,
        color: Colors.red,
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
