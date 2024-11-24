import 'package:caccu_app/presentation/Screen/Home/HomeViewModel.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../data/entity/walletEntity.dart';
import '../monthlyWalletViewModel.dart';

class AddWalletScreen extends StatefulWidget {

  const AddWalletScreen({
    super.key,

  });

  @override
  _AddWalletScreenState createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends State<AddWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  // late TextEditingController _currencyController;

  void _add(BuildContext context) async{
    if (_formKey.currentState!.validate()) {
      // Gọi hàm saveChanges từ ViewModel
      final newName = _nameController.text;
      bool a = await Provider.of<HomeViewModel>(context, listen: false)
          .addWallet(context, newName);
      print('aaaaaaaaaaaaaaaaaaa: $a');

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm ví'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name Wallet'),
                // keyboardType: TextInputType.number,
                // inputFormatters: [
                //   FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
                // ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid Name Wallet';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  // _saveChanges(context);
                  _add(context);

                },
                child: Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
