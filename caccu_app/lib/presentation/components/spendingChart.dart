import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/entity/transactionEntity.dart';

class SpendingChart extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final int month; // Tháng cần hiển thị
  final int year;  // Năm cần hiển thị

  const SpendingChart({
    super.key,
    required this.transactions,
    required this.month,
    required this.year,
  });

  //===============================================================================
  List<FlSpot> generateSpots(List<TransactionEntity> transactions) {
    // Tạo danh sách đầy đủ các ngày trong tháng
    final int daysInMonth = DateTime(year, month + 1, 1).subtract(Duration(days: 1)).day;

    Map<int, double> aggregatedData = {};

    // Cộng dồn giá trị price theo ngày
    for (var transaction in transactions) {
      final transactionDate = transaction.time;
      if (transactionDate != null &&
          transactionDate.month == month &&
          transactionDate.year == year) {
        final day = transactionDate.day;
        aggregatedData[day] = (aggregatedData[day] ?? 0) + transaction.price;
      }
    }

    // Điền giá trị 0 cho các ngày không có giao dịch
    List<FlSpot> spots = [];
    for (int i = 1; i <= daysInMonth; i++) {
      spots.add(FlSpot(i.toDouble(), aggregatedData[i] ?? 0));
    }

    return spots;
  }

  //===============================================================================
  double daysInMonth() {
    // Lấy tháng tiếp theo và đặt ngày là 0, sẽ tự động trả về ngày cuối cùng của tháng hiện tại
    var firstDayOfNextMonth = (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);
    var lastDayOfCurrentMonth = firstDayOfNextMonth.subtract(Duration(days: 1));
    return lastDayOfCurrentMonth.day.toDouble();
  }

  //===============================================================================
  String formatCurrency(int value) {
    final formatter = NumberFormat("#,##0", "vi_VN"); // "vi_VN" là mã ngôn ngữ Tiếng Việt
    return formatter.format(value);
  }

  //==================================================================================
  @override
  Widget build(BuildContext context) {
    final spots = generateSpots(transactions);

    return Container(
      padding: const EdgeInsets.only(left: 20, top: 16, right: 16, bottom: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade600,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Báo cáo tháng $month/$year',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: false,
                    color: Colors.red,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: Colors.orangeAccent),
                  ),
                ],
                minX: 1,
                maxX: daysInMonth(),
                minY: 0,
                maxY: spots.isNotEmpty
                    ? spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) * 1.2
                    : 10,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value == 1 || value == daysInMonth()) {
                          return Text(
                            '${value.toInt()}/$month',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          );
                        }
                        return Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((touchedSpot) {
                        final day = touchedSpot.x.toInt();
                        final price = touchedSpot.y;
                        return LineTooltipItem(
                          'Ngày: $day/$month\nĐã chi: ${formatCurrency(price.toInt())}',
                          TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
