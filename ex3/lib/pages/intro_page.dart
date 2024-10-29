import 'package:ex3/components/splash_screen.dart';

import 'package:flutter/material.dart';

import 'home_page.dart';

class IntroPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _IntroPageState();

}


class _IntroPageState extends State<IntroPage>{
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[300],
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Padding(
                padding: const EdgeInsets.all(0),
                child: Image.asset(
                  'lib/img/unique.png',
                  height: 240,
                ),
              ),

              const SizedBox(height: 130),

              //title
              Text(
                'Just Do It',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28
                ),
              ),

              const SizedBox(height: 30),

              // subtitle
              Text(
                'Brand new clothers and custom kicks made with premium quality',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey[700]
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              GestureDetector(
                onTapDown: (_) {
                  // Khi nhấn vào, đổi trạng thái
                  setState(() {
                    _isPressed = true;
                  });
                },
                onTapUp: (_) {
                  // Khi thả ra, đổi lại màu và điều hướng
                  setState(() {
                    _isPressed = false;
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SplashScreenWrapper(nextScreen: HomePage()),
                    ),
                  );
                },


                // onTap: ()=> Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const SplashScreenWrapper(nextScreen: HomePage()),
                //   ),
                // ),

                onTapCancel: () {
                  // Trường hợp bấm nhưng di chuyển ngón tay ra ngoài vùng
                  setState(() {
                    _isPressed = false;
                  });
                },


                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    // _isPressed mặc định là false, khi onTapUp thì đổi thành true
                    color: _isPressed ? Colors.grey[900] : Colors.grey[400], // Đổi màu khi nhấn
                    borderRadius: BorderRadius.circular(12)
                  ),
                  padding: const EdgeInsets.all(25),
                  child: const Center(
                    child: Text(
                      'Shop Now',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

}