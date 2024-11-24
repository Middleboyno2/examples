import 'package:caccu_app/presentation/Screen/Bill/billViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../components/checkboxSmile.dart';

class AddBillScreen extends StatefulWidget {
  const AddBillScreen({super.key});

  @override
  _AddBillScreenState createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  late Future<void> _init;
  String? selectedCateId;
  late TextEditingController amountController = TextEditingController();
  late TextEditingController nameController = TextEditingController();
  DateTime? selectedDate;
  late bool isActive = false;
  late BillViewModel billViewModel;

  @override
  void initState() {
    super.initState();
    billViewModel = Provider.of<BillViewModel>(context, listen: false);
    _init = Provider.of<BillViewModel>(context,listen: false).reload();


    // // Gán dữ liệu ban đầu của transaction vào các trường
    // selectedCateId = widget.transaction.categoryId.id;
    // selectedWalletId = widget.transaction.walletId.id;
    // amountController = TextEditingController(text: widget.transaction.price.toString());
    // noteController = TextEditingController(text: widget.transaction.notes ?? '');
    // selectedDate = widget.transaction.time;
  }

  void _add(BuildContext context) async {
    // Kiểm tra các trường dữ liệu
    if (selectedCateId == null ||
        amountController.text.isEmpty ||
        nameController.text.isEmpty ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }
    await BillViewModel().addBill2(selectedCateId!, nameController.text, double.tryParse(amountController.text)!, selectedDate!, isActive);

    // Log dữ liệu chỉnh sửa (thay bằng logic cập nhật thực tế)
    print("Category Path: $selectedCateId");
    print("Amount: ${amountController.text}");
    print("Note: ${nameController.text}");
    print("Date: $selectedDate");
    print("Repeat: $isActive");

    // // Hiển thị thông báo thành công
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("Transaction updated successfully!")),
    // );
    // Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot)
      {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Padding(
                padding: EdgeInsets.only(left: 100),
                child: Text(
                  "HÓA ĐƠN",
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
                padding: EdgeInsets.only(top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Input field for transaction amount
                    TextFormField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        hintText: 'Nhập số tiền của hóa đơn',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Dropdown for selecting image
                    const Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedCateId,
                      hint: const Text("Select Category"),
                      items: billViewModel.categories.map((image) {
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
                    const SizedBox(height: 20),


                    // Input field for transaction note
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Note',
                        hintText: 'Nhập tên hóa đơn',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                    ),
                    const SizedBox(height: 20),

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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Repeat', style:
                        TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                        ),

                        SmileFaceCheckbox(
                          height: 30.0,
                          isActive: isActive,
                          onPress: () {
                            setState(() {
                              isActive = !isActive;
                            });
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Submit button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _add(context);
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
      }
    );
  }
}