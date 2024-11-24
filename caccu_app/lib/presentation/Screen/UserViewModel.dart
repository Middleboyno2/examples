import 'package:caccu_app/data/service/LocalStorage.dart';
import 'package:caccu_app/data/usecase/userUsecase.dart';
import 'package:caccu_app/presentation/Screen/Login.dart';

import 'package:caccu_app/presentation/Screen/navigator.dart';
import 'package:flutter/material.dart';



class UserViewModel with ChangeNotifier{
  // error textFíeld email
  String? emailError;
  // error textField password
  String? passwordError;
  // check
  bool status = false;


  // Phương thức để kiểm tra các giá trị nhập vào
  Future<bool> validateInputEmail(String email) async {
    // emailError ="";

    if (email.isEmpty ) {
      // kiểm tra định dạng email
      emailError = "Email không được để trống!";
      return false;
    }else{
      // bool check = await UserUseCase().checkEmail(email);
      // if (check){
      //   emailError = "Email đã tồn tại!";
      // }
    }
    return true;
  }

  // Phương thức để kiểm tra các giá trị nhập vào
  bool validateInputPassword(String password) {
    // passwordError = "";
    if (password.isEmpty) {
      // kiểm tra định dạng password
      passwordError = "Mật khẩu không được để trống!";
      return false;
    }
    return true;
  }
  // hàm chuyển giao diện khi đủ điều kiện
  Future<void> nextScreen(BuildContext context0, String email, String password) async {
    bool checkEmail = await validateInputEmail(email);
    bool checkPass = validateInputPassword(password);

    if (checkEmail && checkPass) {
      // Đợi kết quả từ hàm checkUserCredentials
      bool credentialsValid = await UserUseCase().checkUserCredentials(email, password);

      if (credentialsValid) {
        await LocalStorageService().saveUserEmail(email);
        print(LocalStorageService().getUserEmail());
        Navigator.pop(context0);
        Navigator.push(
          context0,
          MaterialPageRoute(builder: (context) => const NavScreen()),
        );
      } else {
        // Hiển thị dialog thông báo lỗi nếu thông tin không hợp lệ
        showDialog(
          context: context0,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Lỗi đăng nhập"),
              content: Text("Email hoặc mật khẩu không đúng, vui lòng thử lại."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Đóng dialog
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
    notifyListeners();
  }


  Future<bool> checkUserLoginStatus() async {
    String? email = LocalStorageService().getUserEmail();
    print(email);
    // Có thể là null
    if (email != null && email.isNotEmpty) {
      status = await UserUseCase().checkAndUpdateUserStatus(email);
      print('checkUserLoginStatus: $status');
      return UserUseCase().checkAndUpdateUserStatus(email);
    }else{
      status = false;
      return false;
    }
    notifyListeners();
  }






// --------------------------------------------- register ----------------------------------------
  void logOut(BuildContext context) async{
    await LocalStorageService().clearUserEmail();
    await LocalStorageService().clearUserId();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );

  }



//
// Phương thức để kiểm tra các giá trị nhập vào
//   bool validateInputEmail(String email) {
//     emailError = "";
//
//     if (email.isEmpty ) {
//       // kiểm tra định dạng email
//       emailError = "Email không được để trống!";
//       return false;
//     }
//     if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(email)) {
//       // Kiểm tra định dạng email
//       emailError = "Email không hợp lệ!";
//       return false;
//     }
//     return true;
//   }

//   // Phương thức để kiểm tra các giá trị nhập vào
//   bool validateInputPassword(String password) {
//     passwordError = "";
//     if (password.isEmpty) {
//       // kiểm tra định dạng password
//       passwordError = "Mật khẩu không được để trống!";
//       return false;
//     }
//     else{
//       if(RegExp(r'[A-Z]').hasMatch(password) && RegExp(r'\d').hasMatch(password) && RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)){
//         return true;
//       }
//       else{
//         // Kiểm tra có ký tự in hoa
//         if (!RegExp(r'[A-Z]').hasMatch(password)) {
//           passwordError = "$passwordError- Mật khẩu phải có ký tự in hoa!\n";
//
//         }
//
//         // Kiểm tra có ký tự số
//         if (!RegExp(r'\d').hasMatch(password)) {
//           passwordError = "$passwordError- Mật khẩu phải có ký tự số!\n";
//
//         }
//
//         // Kiểm tra có ký tự đặc biệt
//         if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
//           passwordError = "$passwordError- Mật khẩu phải có ký tự đặc biệt!.";
//
//         }
//       }


}