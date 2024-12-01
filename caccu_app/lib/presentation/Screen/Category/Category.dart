import 'package:caccu_app/data/entity/categoryEntity.dart';
import 'package:caccu_app/presentation/Screen/Category/updateCate.dart';
import 'package:caccu_app/presentation/Screen/Other/OtherViewModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'categoryViewModel.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {


  @override
  void initState(){
    super.initState();
    Provider.of<CategoryViewModel>(context, listen: false).reload();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            "DANH MỤC",
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), // Biểu tượng nút reload
            onPressed: () async {
              // Gọi hàm reload từ ViewModel
              await Provider.of<CategoryViewModel>(context, listen: false)
                  .reload();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Danh sách đã được làm mới!")),
              );
            },
            tooltip: 'Reload Transactions', // Tooltip hiển thị khi giữ nút
          ),
        ],
        backgroundColor: Colors.red.shade400,
      ),
      body: Consumer<CategoryViewModel>(
          builder: (context, viewModel, child) {
            return ListView.builder(
              itemCount: viewModel.categories.length,
              itemBuilder: (context, index) {
                final data = viewModel.categories[index];
                // Debug từng giá trị của data
                print("Category Name: ${data.name}, Icon: ${data.icon}, Limit: ${data.limit}");
                return ListTile(
                  leading: Image.asset(data.icon),
                  title: Text(data.name),
                  // subtitle: Text('${formatter.format(data.limit)} đ'),
                  trailing: Text(
                    '${formatter.format(data.limit)} vnđ',
                    style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                  ),
                  onTap: () {
                    // Điều hướng đến giao diện khác
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateCategory(category: data),
                      ),
                    );
                  },
                );
              },
            );

          }
      ),
    );
  }
}
