import 'package:caccu_app/presentation/components/pieChart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/entity/categoryEntity.dart';

class CategorySpendingComponent extends StatelessWidget {
  final List<Map<String, dynamic>> categorySpending;
  const CategorySpendingComponent({
    super.key,
    required this.categorySpending
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 5, left: 12, right: 12, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade600,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chi tiêu theo danh mục tháng ${(DateTime.now().month).toString()}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PieChartSpending(categorySpending: categorySpending)),
                );
              },
              child: const Text(
                'Xem tất cả',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: categorySpending.length,
              itemBuilder: (context, index) {
                final data = categorySpending[index];
                return ListTile(
                  leading: Image.asset(data['icon']),
                  title: Text(data['categoryName']),
                  subtitle: Text('${formatter.format(data['totalPrice'])} đ'),
                  trailing: Text(
                    '${((data['totalPrice']/data['totalAllPrice'])*100).toStringAsFixed(0)}%',
                    style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                  ),
                );
              },
            )
          ),

        ],
      ),
    );
  }
}
