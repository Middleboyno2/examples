import 'package:caccu_app/presentation/Screen/Home/Home.dart';
import 'package:caccu_app/presentation/Screen/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/spendingChart.dart';
import 'MonthlyAnalysisScreen.dart';

class MonthlySummaryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> summary;
  const MonthlySummaryScreen({super.key, required this.summary});

  @override
  State<MonthlySummaryScreen> createState() => _MonthlySummaryScreenState();
}

class _MonthlySummaryScreenState extends State<MonthlySummaryScreen> {

  final formatter = NumberFormat('#,###', 'vi_VN');

  // get day in current month
  int getDaysInCurrentMonth() {
    DateTime now = DateTime.now(); // Lấy ngày hiện tại
    int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    return daysInMonth;
  }
  @override
  Widget build(BuildContext context) {
    final data = widget.summary[0];
    return SingleChildScrollView(
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text('Tổng kết tháng ${DateTime.now().month - 1}', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Tổng số tiền đã tiêu',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${formatter.format(data['totalAllPrice'])} đ',
                      style: TextStyle(fontSize: 16, color: Colors.redAccent),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      'Tiêu trung bình/ngày',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${formatter.format((data['totalAllPrice'])/getDaysInCurrentMonth())} vnđ",
                      style: TextStyle(fontSize: 16, color: Colors.redAccent),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
                height: 600,
                child: SpendingChart(
                    transactions: data['transactions'],
                    month: DateTime.now().month-1,
                    year: DateTime.now().year
                )
            ),
            const SizedBox(height: 30),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (_) => MonthlyAnalysisScreen(summary: widget.summary)),
            //     );
            //   },
            //   child: Text('Next'),
            // ),
          ],
        ),
      ),
    );
  }
}
