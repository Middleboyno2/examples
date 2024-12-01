import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../data/entity/categoryEntity.dart';
import 'categoryViewModel.dart';

class UpdateCategory extends StatefulWidget {
  final CategoryEntity category;
  const UpdateCategory({super.key, required this.category});

  @override
  State<UpdateCategory> createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _balanceController;
  // late TextEditingController _currencyController;

  @override
  void initState() {
    super.initState();
    _balanceController = TextEditingController(text: widget.category.limit.toString());
    // _currencyController = TextEditingController(text: widget.monthlyWallet.currency);
  }

  @override
  void dispose() {
    _balanceController.dispose();
    // _currencyController.dispose();
    super.dispose();
  }
  void _updateChanges(BuildContext context, CategoryEntity category) async{
    if (_formKey.currentState!.validate()) {
      // Gọi hàm saveChanges từ ViewModel
      final newBalance = double.tryParse(_balanceController.text) ?? 0.0;
      bool isSaved = await Provider.of<CategoryViewModel>(context, listen: false)
          .updateCate(category.categoryId!, category.name, category.icon, newBalance);

      // Nếu lưu thành công, quay lại màn hình trước đó
      if (isSaved) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật danh mục tháng ${DateTime.now().month}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _balanceController,
                decoration: InputDecoration(labelText: 'Limit'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid balance';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  _updateChanges(context, widget.category);
                },
                child: Text('Change'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

