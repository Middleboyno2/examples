import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SpendingChart extends StatelessWidget {
  const SpendingChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 16, right: 16, bottom: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Báo cáo tháng này',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Xem báo cáo',
              style: TextStyle(
                color: Colors.green,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: 16),
          // Đảm bảo LineChart có kích thước xác định
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  // leftTitles: AxisTitles(
                  //   sideTitles: SideTitles(
                  //     showTitles: true,
                  //     getTitlesWidget: (value, meta) {
                  //       return Text(
                  //         value.toString(),
                  //         style: const TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 12,
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value == 1) {
                          return const Text(
                            '01/11',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          );
                        }
                        if (value == 30) {
                          return const Text(
                            '30/11',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                minX: 1,
                maxX: 30,
                minY: 0,
                maxY: 10,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(1, 0),
                      FlSpot(5, 1),
                      FlSpot(10, 2),
                      FlSpot(15, 2.5),
                      FlSpot(20, 5),
                      FlSpot(25, 6.5),
                      FlSpot(30, 9),
                    ],
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.red.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    color: Colors.red,
                  ),
                  SizedBox(width: 4),
                  Text('Tháng này', style: TextStyle(color: Colors.white)),
                ],
              ),
              SizedBox(width: 16),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 4),
                  Text('Trung bình 3 tháng trước', style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              'Xu hướng báo cáo',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
