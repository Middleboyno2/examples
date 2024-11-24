import 'package:caccu_app/presentation/Screen/Account/UserViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  TextEditingController textName = TextEditingController();
  TextEditingController textPhone = TextEditingController();
  TextEditingController textEmail = TextEditingController();
  TextEditingController textPassword = TextEditingController();
  TextEditingController textConfirmPassword = TextEditingController();
  //===============================================================================

  //===============================================================================
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
        // elevation: 0,
        // backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'REGISTER',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),
            // Name field
            TextField(
              controller: textName,
              decoration: InputDecoration(
                labelText: 'name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                errorText: context.watch<UserViewModel>().textNameError
              ),
            ),
            SizedBox(height: 20),
            // Phone field
            TextFormField(
              controller: textPhone,
              decoration: InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                errorText: context.watch<UserViewModel>().textPhoneError
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
              ],
            ),
            SizedBox(height: 20),
            // Email field
            TextField(
              controller: textEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Johndoe@exemple.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                errorText: context.watch<UserViewModel>().textEmailError
              ),
            ),
            SizedBox(height: 20),
            // Password field
            TextField(
              controller: textPassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                errorText: context.watch<UserViewModel>().textPasswordError
              ),
            ),
            SizedBox(height: 20),
            // Confirm Password field
            TextField(
              controller: textConfirmPassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                errorText: context.watch<UserViewModel>().confirmError
              ),
            ),
            SizedBox(height: 30),
            // Finish button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle registration logic here
                  userViewModel.register(context, textName.text, textPhone.text,
                      textEmail.text, textPassword.text, textConfirmPassword.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
