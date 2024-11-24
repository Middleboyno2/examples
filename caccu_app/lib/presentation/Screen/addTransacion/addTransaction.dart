import 'package:caccu_app/presentation/Screen/addTransacion/addTransactionViewModel.dart';
import 'package:caccu_app/presentation/Screen/transaction/TransactionViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../theme/listImage.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  _TransactionFormScreenState createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<AddTransactionScreen> {

  late Future<void> _initializeFuture;
  // State variables
  String? selectedCateId;
  String? selectedWalletId; // Selected wallet
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  DateTime? selectedDate; // Selected date

  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();
    // Gọi initialize() khi khởi tạo màn hình
    _initializeFuture = Provider.of<AddTransactionViewModel>(context, listen: false).reload();
  }



  Future<void> _pickDateTime() async {
    // Chọn ngày
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 2, 0),
    );

    if (pickedDate == null) return;

    // Chọn giờ/phút
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    // Kết hợp ngày và giờ
    setState(() {
      selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _add(BuildContext context, AddTransactionViewModel addTransactionViewModel) async{

    // Handle form submission
    if (selectedCateId == null ||
        amountController.text.isEmpty ||
        noteController.text.isEmpty ||
        selectedDate == null ||
        selectedWalletId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      initState();
      return;
    }
    await addTransactionViewModel.addTransaction(selectedCateId!, selectedWalletId!, double.tryParse(amountController.text)!, noteController.text, selectedDate!);
    // Log the form data (replace with actual form submission logic)
    print("Category Path: $selectedCateId");
    print("Amount: ${amountController.text}");
    print("Note: ${noteController.text}");
    print("Date: $selectedDate");
    print("Wallet: $selectedWalletId");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Transaction added successfully!")),
    );

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeFuture,
        builder: (context, snapshot)
        {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Hiển thị khi đang tải
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Hiển thị khi có lỗi
          } else {
            return Consumer<AddTransactionViewModel>(
              builder: (context, addTransactionViewModel, child){
                return Scaffold(
                  appBar: AppBar(
                    title: Center(
                      child: const Text(
                        "THÊM GIAO DỊCH",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Dropdown for selecting image
                          const Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: selectedCateId,
                            hint: const Text("Select Category"),
                            items: addTransactionViewModel.categories.map((image) {
                              return DropdownMenuItem<String>(
                                value: image.categoryId,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 20),
                                    Image.asset(
                                      image.icon, // Thay đổi đường dẫn hình ảnh của bạn
                                      height: 30,
                                    ),
                                    SizedBox(width: 20),
                                    Text(image.name),

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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid Name Wallet';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Date picker for transaction date
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  selectedDate == null
                                      ? "No date/time selected"
                                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} "
                                      "${selectedDate!.hour}:${selectedDate!.minute}:${selectedDate!.second}",
                                ),
                              ),
                              ElevatedButton(
                                onPressed: _pickDateTime,
                                child: const Text("Pick Date & Time"),
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
                                _add(context, addTransactionViewModel);

                              },
                              child: const Text("Add Transaction"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            );

          }
        }
    );
  }
}
