import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'transaction/TransactionViewModel.dart';



class addTransactionScreen extends StatefulWidget {
  @override
  _addTransactionScreenState createState() => _addTransactionScreenState();
}

class _addTransactionScreenState extends State<addTransactionScreen> {
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final TransactionViewMo = Provider.of<TransactionViewModel>(context, listen: false);
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Category ID
              TextFormField(
                decoration: InputDecoration(labelText: "Category ID"),
                onChanged: (value) => TransactionViewMo.categoryId = value,
                validator: (value) =>
                value == null || value.isEmpty ? "Category ID là bắt buộc" : null,
              ),
              SizedBox(height: 10),

              // Note
              TextFormField(
                decoration: InputDecoration(labelText: "Ghi chú"),
                onChanged: (value) => TransactionViewMo.note = value,
              ),
              SizedBox(height: 10),

              // Price
              TextFormField(
                decoration: InputDecoration(labelText: "Giá trị"),
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                TransactionViewMo.price = double.tryParse(value) ?? 0,
                validator: (value) =>
                value == null || double.tryParse(value) == null
                    ? "Giá trị phải là số"
                    : null,
              ),
              SizedBox(height: 10),

              // Wallet ID
              TextFormField(
                decoration: InputDecoration(labelText: "Wallet ID"),
                onChanged: (value) => TransactionViewMo.walletId = value,
                validator: (value) =>
                value == null || value.isEmpty ? "Wallet ID là bắt buộc" : null,
              ),
              SizedBox(height: 10),

              // User ID
              TextFormField(
                decoration: InputDecoration(labelText: "User ID"),
                onChanged: (value) => TransactionViewMo.userId = value,
                validator: (value) =>
                value == null || value.isEmpty ? "User ID là bắt buộc" : null,
              ),
              SizedBox(height: 10),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (TransactionViewMo.validateAndSave()) {
                    TransactionViewMo.saveTransaction();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Giao dịch đã được lưu!")));
                  }else{
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Thông báo"),
                          content: Text("không thành công"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Đóng dialog
                              },
                              child: Text("Đồng ý"),
                            ),
                          ],
                        );
                      }
                    );
                  }
                },
                child: Text("Lưu Giao Dịch"),
              ),
            ],
          ),
        ),
      );

  }
}
