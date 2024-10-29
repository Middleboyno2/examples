

import 'package:flutter/material.dart';

import '../pages/home_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Màn hình chờ với Progress Indicator
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 30),
            Text('Vui lòng chờ trong giây lát...')
          ],
        ),
      ),
    );
  }
}


class SplashScreenWrapper extends StatefulWidget {
  final Widget nextScreen;
  const SplashScreenWrapper({super.key, required this.nextScreen});


  @override
  State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  @override
  void initState() {
    super.initState();

    // Đợi 5 giây rồi chuyển đến màn hình HomePage
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget.nextScreen),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();  // Hiển thị màn hình chờ
  }
}