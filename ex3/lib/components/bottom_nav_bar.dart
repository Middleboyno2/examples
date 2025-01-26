
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomAppBar extends StatelessWidget{
  final Function(int)? onTabChange;
  const   CustomBottomAppBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: GNav(
        color: Colors.grey[400],
        activeColor: Colors.grey.shade700,
        tabActiveBorder: Border.all(color: Colors.white),
        tabBackgroundColor: Colors.grey.shade200,
        // padding: EdgeInsets.symmetric(vertical: 20),
        mainAxisAlignment: MainAxisAlignment.center,
        tabBorderRadius: 16,
        onTabChange: (value) => onTabChange!(value),
        tabs: const [
          GButton(
            icon: Icons.home,
            text: "Shop",
            // margin: EdgeInsets.only(right: 20),

          ),

          GButton(
            icon: Icons.shopping_bag_rounded,
            text: "Cart",
            // margin: EdgeInsets.only(left: 20),
          ),


        ],

      ),
    );
  }

}