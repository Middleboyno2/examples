import 'package:flutter/material.dart';
import 'package:caccu_app/data/entity/monthlyWalletEntity.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'monthlyWalletViewModel.dart';

class EditMonthlyWalletScreen extends StatefulWidget {
  final MonthlyWalletEntity monthlyWallet;


  const EditMonthlyWalletScreen({
    super.key,
    required this.monthlyWallet,
  });

  @override
  _EditMonthlyWalletScreenState createState() => _EditMonthlyWalletScreenState();
}

class _EditMonthlyWalletScreenState extends State<EditMonthlyWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _balanceController;
  // late TextEditingController _currencyController;

  @override
  void initState() {
    super.initState();
    _balanceController = TextEditingController(text: widget.monthlyWallet.availableBalance.toString());
    // _currencyController = TextEditingController(text: widget.monthlyWallet.currency);
  }

  @override
  void dispose() {
    _balanceController.dispose();
    // _currencyController.dispose();
    super.dispose();
  }

  void _saveChanges(BuildContext context) async{
    if (_formKey.currentState!.validate()) {
      // Gọi hàm saveChanges từ ViewModel
      final newBalance = double.tryParse(_balanceController.text) ?? 0.0;
      bool isSaved = await Provider.of<MonthlyWalletViewModel>(context, listen: false)
          .saveChanges(context, widget.monthlyWallet, newBalance);

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
        title: Text('Cập nhật thông tin ví tháng ${widget.monthlyWallet.month}'),
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
                decoration: InputDecoration(labelText: 'Available Balance'),
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
                  _saveChanges(context);
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
