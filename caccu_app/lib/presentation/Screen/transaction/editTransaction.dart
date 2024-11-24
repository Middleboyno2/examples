import 'package:caccu_app/data/entity/transactionEntity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../addTransacion/addTransactionViewModel.dart';
import 'TransactionViewModel.dart';

class EditTransactionScreen extends StatefulWidget {
  final TransactionEntity transaction;

  const EditTransactionScreen({super.key, required this.transaction});

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  late Future<void> _initializeFuture;
  late String? selectedCateId;
  late String? selectedWalletId;
  late TextEditingController amountController;
  late TextEditingController noteController;
  late DateTime? selectedDate;
  late AddTransactionViewModel addTransactionViewModel;

  @override
  void initState() {
    super.initState();
    // Gán addTransactionViewModel từ Provider
    addTransactionViewModel = Provider.of<AddTransactionViewModel>(context, listen: false);

    // Gọi hàm reload
    _initializeFuture = addTransactionViewModel.reload();

    // Gán dữ liệu ban đầu của transaction vào các trường
    selectedCateId = widget.transaction.categoryId.id;
    selectedWalletId = widget.transaction.walletId.id;
    amountController = TextEditingController(text: widget.transaction.price.toString());
    noteController = TextEditingController(text: widget.transaction.notes ?? '');
    selectedDate = widget.transaction.time;
  }

  void _edit(BuildContext context) async {
    // Kiểm tra các trường dữ liệu
    if (selectedCateId == null ||
        amountController.text.isEmpty ||
        noteController.text.isEmpty ||
        selectedDate == null ||
        selectedWalletId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }
    await TransactionViewModel().updateTransaction(widget.transaction.transactionId!, selectedCateId!, selectedWalletId!, double.tryParse(amountController.text)!, noteController.text, selectedDate!);

    // Log dữ liệu chỉnh sửa (thay bằng logic cập nhật thực tế)
    print("Category Path: $selectedCateId");
    print("Amount: ${amountController.text}");
    print("Note: ${noteController.text}");
    print("Date: $selectedDate");
    print("Wallet: $selectedWalletId");

    // // Hiển thị thông báo thành công
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("Transaction updated successfully!")),
    // );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "CHỈNH SỬA GIAO DỊCH",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.red.shade400,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Input field for transaction amount
                    TextFormField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        hintText: 'Nhập số tiền giao dịch',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Dropdown for selecting category
                    const Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedCateId,
                      hint: const Text("Select Category"),
                      items: addTransactionViewModel.categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category.categoryId,
                          child: Row(
                            children: [
                              Image.asset(
                                category.icon,
                                height: 30,
                              ),
                              const SizedBox(width: 10),
                              Text(category.name),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCateId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Input field for transaction note
                    TextFormField(
                      controller: noteController,
                      decoration: InputDecoration(
                        labelText: 'Note',
                        hintText: 'Nhập nội dung giao dịch',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Date picker for transaction date
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedDate == null
                                ? "No date selected"
                                : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(DateTime.now().year - 1),
                              lastDate: DateTime(DateTime.now().year + 1),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                          child: const Text("Pick Date"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Dropdown for selecting wallet
                    const Text("Wallet", style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedWalletId,
                      hint: const Text("Select Wallet"),
                      items: addTransactionViewModel.wallets.map((wallet) {
                        return DropdownMenuItem<String>(
                          value: wallet.walletId,
                          child: Text(wallet.walletName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedWalletId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Submit button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _edit(context);
                        },
                        child: const Text("Edit Transaction"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}