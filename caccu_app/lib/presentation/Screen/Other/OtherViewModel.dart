

import 'package:caccu_app/presentation/Screen/Account/UserViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OtherViewModel with ChangeNotifier{
  UserViewModel userViewModel = UserViewModel();
  Future<void> logout(BuildContext context) async {
    userViewModel.logOut(context);
    Fluttertoast.showToast(
      msg: "Bạn đã đăng xuất tài khoản!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.white,
      textColor: Colors.black54,
    );
  }

  Future<void> reload() async{

  }
}