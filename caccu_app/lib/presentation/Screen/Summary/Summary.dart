import 'package:caccu_app/presentation/Screen/Summary/ImprovementScreen.dart';
import 'package:caccu_app/presentation/Screen/Summary/MonthlyAnalysisScreen.dart';
import 'package:caccu_app/presentation/Screen/Summary/monthlySummary.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SummaryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> summary;
  const SummaryScreen({super.key, required this.summary});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  PageController _pageController = PageController();
  bool _isPressed = false;
  bool _isPressed1 = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("lib/img/background.jpg")
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(Icons.close), // Biểu tượng nút reload
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (_)=> NavScreen()));
                Navigator.pop(context);
              },
              tooltip: 'Close', // Tooltip hiển thị khi giữ nút
            ),
          ],
        ),
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              children: [
                MonthlySummaryScreen(summary: widget.summary),
                MonthlyAnalysisScreen(summary: widget.summary),
                ImprovementScreen(summary: widget.summary)
              ],
            ),
            Container(
              alignment: Alignment(0, 0.9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      _pageController.previousPage(duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
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
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      // height: 80,
                      decoration: BoxDecoration(
                        // _isPressed mặc định là false, khi onTapUp thì đổi thành true
                          color: _isPressed ? Colors.grey[400]: Colors.transparent, // Đổi màu khi nhấn
                          borderRadius: BorderRadius.circular(12)
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      child: const Text(
                        'Previous',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 30),

                  SmoothPageIndicator(controller: _pageController, count: 3),

                  SizedBox(width: 50),

                  GestureDetector(
                    onTap: (){
                      _pageController.nextPage(duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                    onTapDown: (_) {
                      // Khi nhấn vào, đổi trạng thái
                      setState(() {
                        _isPressed1 = true;
                      });
                    },
                    onTapUp: (_) {
                      // Khi thả ra, đổi lại màu và điều hướng
                      setState(() {
                        _isPressed1 = false;
                      });
                    },
                    child: AnimatedContainer(

                      duration: const Duration(milliseconds: 300),
                      // height: 80,
                      decoration: BoxDecoration(
                        // _isPressed mặc định là false, khi onTapUp thì đổi thành true
                          color: _isPressed1 ?  Colors.grey[400]: Colors.transparent, // Đổi màu khi nhấn
                          borderRadius: BorderRadius.circular(12)
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      child: Text(
                        'Next',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
