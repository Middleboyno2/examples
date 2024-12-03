import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ImprovementScreen extends StatelessWidget {
  final List<Map<String, dynamic>> summary; // Danh mục cần cải thiện

  const ImprovementScreen({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
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
    //=====================================================================

    final List<String> a = [
      'Tiêu tiền hoang phí đã lâu rồi\nTiền tài như nước chảy xuôi dòng\nĐốt tiền chẳng tiếc những ngày qua\nCuối cùng tay trắng lệ tuôn trào',
      'Tiền bạc tiêu xài chẳng nghĩ suy\nMua sắm xa hoa quên ngày mai\nKhi túi cạn khô, lòng chợt hiểu\nHối tiếc muộn màng có được chi',
      'Đời người ngắn ngủi tựa mây trôi\nTiền bạc tiêu tan, lòng chơi vơi\nPhung phí hôm nay, khổ ngày mai\nGiật mình tỉnh giấc, ôi xa vời',
      'Tiêu tiền không nghĩ đến ngày mai\nPhung phí thời gian, phung phí tài\nKhi trắng tay mới hiểu ra rằng\nTiếc nuối cũng muộn, đắng cay thay'
    ];

    final List<String> b = [
      'Người hỏi tôi về chuyện nghĩa nhân\nTôi cười nhạt nhẽo đắng muôn phần\nKhông tiền lắm kẻ nhìn coi rẻ\nLắm bạc muôn người lại kết thân.',
      'Túi trống không, lòng buồn bã\nĐêm dài lạnh lẽo, bước cô đơn\nÁnh đèn phố thị xa vời vợi\nTiền bạc thiếu thốn, mộng tan biến',
      'Ngày qua chỉ có gió và sương\nCơm áo gạo tiền thiếu trăm đường\nƯớc mơ giản dị sao khó quá\nNghèo khó đeo mang suốt chặng trường',
      'Cơm chưa đủ no, áo chẳng lành\nTiền tiêu không có, cảnh chênh vênh\nNhìn người sung túc lòng tê tái\nMong ước cuộc sống bớt mong manh'
    ];
    final List<String> c = [
      'lib/img/nice.png',
      'lib/img/think.png',
      'lib/img/poor.png'
    ];

    // Chọn text ngẫu nhiên từ danh sách
    String randomText;
    String img;
    if (summary.any((s) => s['totalAllPrice'].toInt() > 100000000)) {
      randomText = a[Random().nextInt(a.length)];
      img = c[1];
    }else if(summary.any((s) => s['totalAllPrice'].toInt() < 10000000)) {
      randomText = b[Random().nextInt(a.length)];
      img = c[2];
    }
    else {
      randomText = 'Bạn đang quản lý tiền của mình rất tốt!';
      img = c[0];
    }

    Widget conditionalWidget = Column(
      children: [
        const SizedBox(height: 40),
        Center(
          child: Text(
            randomText,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Image.asset(
            img, // Icon từ đường dẫn
            width: 120,       // Kích thước icon
            height: 120,
          ),
        )
      ]
    );
    //=====================================================================
    return Container(
      color: Colors.transparent,

      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text('Tổng kết phân tích tháng', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold))),
            const SizedBox(height: 20),
            Text(
              'Mục cần cải thiện chi tiêu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: Column(
                children: [
                  // List of items
                  Expanded(
                    child: ListView.builder(
                      itemCount: exceededCategories.length,
                      itemBuilder: (context, index) {
                        final category = exceededCategories[index];
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
                                    width: 50,       // Kích thước icon
                                    height: 50,
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

            conditionalWidget
        
          ],
        ),
      ),
    );
  }

}
