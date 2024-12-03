import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'ImprovementScreen.dart';

class MonthlyAnalysisScreen extends StatelessWidget {
  final List<Map<String, dynamic>> summary;

  const MonthlyAnalysisScreen({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> topCategories = [];
    for (int i = 0; i < summary.length && i < 4; i++){
      topCategories.add({
        'categoryName': summary[i]['categoryName'],
        'totalPrice': summary[i]['totalPrice'],
        'totalAllPrice' : summary[i]['totalAllPrice'],
        'icon': summary[i]['icon'],
      });
    }
    final List<Map<String, dynamic>> exceededCategories = [];
    for (int i = 0; i < summary.length; i++){
      if(summary[i]['totalPrice'] > summary[i]['limit']){
        exceededCategories.add({
          'categoryName': summary[i]['categoryName'],
          'totalPrice': summary[i]['totalPrice'],
          'totalAllPrice' : summary[i]['totalAllPrice'],
          'icon': summary[i]['icon'],
          'limit': summary[i]['limit']
        });
      }
    }
    return SingleChildScrollView(
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text('Phân tích chi tiêu tháng ${DateTime.now().month - 1}', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Text(
              'Top 4 danh mục chi tiêu nhiều nhất',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 300,
              child: Column(
                children: [
                  // List of items
                  Expanded(
                    child: ListView.builder(
                      itemCount: topCategories.length,
                      itemBuilder: (context, index) {
                        final category = topCategories[index];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.only(left: 90, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.transparent,
                            border: Border.all(color: Colors.grey, width: 1.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    category['icon'], // Icon từ đường dẫn
                                    width: 40,       // Kích thước icon
                                    height: 40,
                                  ),
                                  const SizedBox(width: 30),
                                  Text(category['categoryName'],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Danh mục vượt giới hạn',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: Column(
                children: [
                  // Header row
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              'Danh mục',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              'Giới hạn',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              'Đã tiêu',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // List of rows
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: exceededCategories.length,
                      itemBuilder: (context, index) {
                        final data = exceededCategories[index];
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.black12)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          data['icon'], // Hiển thị ảnh từ đường dẫn
                                          width: 24,    // Chiều rộng ảnh
                                          height: 24,   // Chiều cao ảnh
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(data['categoryName']),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        NumberFormat.currency(locale: "vi_VN", symbol: "vnđ")
                                            .format(data['limit']),
                                        style: TextStyle(color: Colors.greenAccent),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        NumberFormat.currency(locale: "vi_VN", symbol: "vnđ")
                                            .format(data['totalPrice']),
                                        style: TextStyle(color: Colors.redAccent),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // Center(
            //   child: ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (_) => ImprovementScreen(exceededCategories: exceededCategories)),
            //       );
            //     },
            //     child: Text('Next'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
