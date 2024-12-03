import 'package:caccu_app/presentation/Screen/Account/Login.dart';
import 'package:caccu_app/presentation/Screen/Account/UserViewModel.dart';
import 'package:caccu_app/presentation/Screen/Category/Category.dart';
import 'package:caccu_app/presentation/Screen/Other/OtherViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/box.dart';
import '../../components/button.dart';

class OtherScreen extends StatelessWidget {
  const OtherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), // Biểu tượng nút reload
            onPressed: () async {
              // Gọi hàm reload từ ViewModel
              await Provider.of<OtherViewModel>(context, listen: false)
                  .logout(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Danh sách đã được làm mới!")),
              );
            },
            tooltip: 'Reload Transactions', // Tooltip hiển thị khi giữ nút
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          buildMenuItem(
            icon: Icons.category, // Biểu tượng
            title: "quản lý danh mục",
            onTap: () {
              // Thực hiện hành động khi nhấn
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Category()
                ),
              );
            },
          ),
          buildMenuItem(
            icon: Icons.calculate,
            title: "xem báo cáo hàng tháng",
            onTap: () {},
          ),
          // buildMenuItem(
          //   icon: Icons.airplanemode_active,
          //   title: "Chế độ máy bay",
          //   onTap: () {},
          // ),
          // buildMenuItem(
          //   icon: Icons.table_chart,
          //   title: "Xuất dữ liệu tới Google Trang tính",
          //   onTap: () {},
          // ),
        ],
      )
    );
  }
  Widget buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.white), // Biểu tượng ở bên trái
          title: Text(
            title,
            style: const TextStyle(color: Colors.white), // Màu chữ
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.white), // Mũi tên bên phải
          onTap: onTap, // Hành động khi nhấn
        ),
        const Divider(
          color: Colors.grey, // Đường kẻ dưới
          height: 1,
          thickness: 0.5,
        ),
      ],
    );
  }
}
