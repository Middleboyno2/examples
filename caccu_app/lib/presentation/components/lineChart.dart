import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class LineChartScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: LineCharWidget(),
    );
  }
}


class Titles{
  static getTitleData() => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 35,
        getTitlesWidget: (value, meta) {
          switch (value.toInt()) {
            case 2:
              return Text(
                '2020',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              );
            case 5:
              return Text(
                '2021',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              );
            case 8:
              return Text(
                '2022',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              );
          }
          return const Text('');
        },
      )
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 35,
        getTitlesWidget: (value, meta){
          switch (value.toInt()) {
            case 10000:
              return Text(
                '10k',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              );
            case 20000:
              return Text(
                '20k',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              );
            case 30000:
              return Text(
                '30k',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              );
            case 40000:
              return Text(
                '40k',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              );
            case 50000:
              return Text(
                '50k',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              );
            case 60000:
              return Text(
                '60k',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              );
            case 70000:
              return Text(
                '70k',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              );
            case 80000:
              return Text(
                '80k',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              );
            case 90000:
              return Text(
                '90k',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              );
          }
          return const Text('');
        }
      ),
    ),
  );
}

class LineCharWidget  extends StatelessWidget{
  final List<Color> gradiantColors = [
    Colors.redAccent,
    Colors.orangeAccent
  ];

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: 100000,
        titlesData: Titles.getTitleData(),
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value){
            return FlLine(
              color: Colors.grey[800],
              strokeWidth: 1
            );
          }
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey[700] ?? Colors.grey,width: 2)
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 30000),
              FlSpot(2.5, 10000),
              FlSpot(4, 50000),
              FlSpot(6, 43000),
              FlSpot(8, 40000),
              FlSpot(9, 30000),
              FlSpot(11, 70000),

            ] ,
            isCurved: true,
            color: Colors.redAccent,
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.orangeAccent
            ),
          ),
        ],
      ),
    );
  }

}
