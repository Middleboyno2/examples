import 'package:ex3/pages/cart_page.dart';
import 'package:ex3/pages/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/cart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cart(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[300],
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black, ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey[300],  // Màu nền AppBar
            foregroundColor: Colors.black,  // Màu của tiêu đề và icon
            elevation: 0,  // Đổ bóng
            centerTitle: true,  // Căn giữa tiêu đề
          ),


          drawerTheme: DrawerThemeData(
            backgroundColor: Colors.grey[900],  // Màu nền của Drawer
            elevation: 5,  // Đổ bóng của Drawer
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),  // Hình dạng của Drawer
            width: 350,  // Độ rộng Drawer
          ),


        ),
        home: IntroPage(),
      ),
    );
  }
}

