import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PieChartSpending extends StatefulWidget {
  final List<Map<String, dynamic>> categorySpending;

  const PieChartSpending({super.key, required this.categorySpending});

  @override
  State<PieChartSpending> createState() => _PieChartSpendingState();
}

class _PieChartSpendingState extends State<PieChartSpending> {
  int touchedIndex = -1;
  final formatter = NumberFormat('#,###', 'vi_VN');
  // get day in current month
  int getDaysInCurrentMonth() {
    DateTime now = DateTime.now(); // Lấy ngày hiện tại
    int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    return daysInMonth;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết khoản chi'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(

          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(

                  children: [
                    Text("Tổng cộng", style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    Text("${formatter.format(widget.categorySpending[0]['totalAllPrice'])} vnđ",
                      style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)
                    )
                  ],
                ),
                const SizedBox(width: 100),
                Column(

                  children: [
                    Text("Trung bình hằng ngày", style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    Text("${formatter.format((widget.categorySpending[0]['totalAllPrice'])/getDaysInCurrentMonth())} vnđ",
                      style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 70),
            AspectRatio(
              aspectRatio: 1.3,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 50,
                  sections: showingSections(),
                ),
              ),
            ),

            const SizedBox(height: 50),
            Expanded(
                child: ListView.builder(
                  itemCount: widget.categorySpending.length,
                  itemBuilder: (context, index) {
                    final data = widget.categorySpending[index];
                    return ListTile(
                      leading: Image.asset(data['icon']),
                      title: Text(data['categoryName']),
                      trailing: Text(
                        '${formatter.format(data['totalPrice'])} vnđ',
                        style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                      ),
                    );
                  },
                )
            ),
          ],
        ),
      )
    );
  }

  List<PieChartSectionData> showingSections() {
    final totalSpending = widget.categorySpending[0]['totalAllPrice'];
    final List<PieChartSectionData> sections = [];

    // Xử lý tối đa 6 mục đầu
    for (int i = 0; i < widget.categorySpending.length && i < 6; i++) {
      final data = widget.categorySpending[i];
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      sections.add(
        PieChartSectionData(
          color: getColor(i),
          value: (data['totalPrice'] / totalSpending) * 100,
          title: '${((data['totalPrice'] / totalSpending) * 100).toStringAsFixed(0)}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
            shadows: shadows,
          ),
          badgeWidget: _Badge(
            data['icon'],
            size: widgetSize,
            borderColor: Colors.black,
          ),
          badgePositionPercentageOffset: .98,
        ),
      );
    }

    // Gộp các mục còn lại
    if (widget.categorySpending.length > 6) {
      final otherTotal = widget.categorySpending
          .skip(6) // Bỏ qua 6 mục đầu
          .fold(0.0, (sum, item) => sum + item['totalPrice']);

      final isTouched = 6 == touchedIndex; // Gán index 6 cho mục "Khác"
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;

      sections.add(
        PieChartSectionData(
          color: Colors.white,
          value: (otherTotal / totalSpending) * 100,
          title: '${((otherTotal / totalSpending) * 100).toStringAsFixed(0)}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
    }

    return sections;
  }


  Color getColor(int index) {
    const colors = [
      Colors.blue,
      Colors.yellow,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.white
    ];
    return colors[index % colors.length];
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
      this.iconPath, {
        required this.size,
        required this.borderColor,
      });

  final String iconPath;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Image.asset(
          iconPath,
        ),
      ),
    );
  }
}
