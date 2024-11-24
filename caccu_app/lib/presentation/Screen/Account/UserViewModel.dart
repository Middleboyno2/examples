import 'package:caccu_app/data/entity/userEntity.dart';
import 'package:caccu_app/data/service/LocalStorage.dart';
import 'package:caccu_app/data/usecase/userUsecase.dart';
import 'package:caccu_app/presentation/Screen/Account/Login.dart';

import 'package:caccu_app/presentation/Screen/navigator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



class UserViewModel with ChangeNotifier{
  // error textFíeld email
  String? emailError;
  // error textField password
  String? passwordError;
  // check
  bool status = false;
  //================================================================================
  String? textNameError;
  String? textEmailError;
  String? textPhoneError;
  String? textPasswordError;
  String? confirmError;
  //================================================================================


  // Phương thức để kiểm tra các giá trị nhập vào
  Future<bool> validateInputEmail(String email) async {
    // emailError ="";

    if (email.isEmpty ) {
      // kiểm tra định dạng email
      emailError = "Email không được để trống!";
      return false;
    }else{
      emailError = null;
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
    }else{
      passwordError = null;
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
    await LocalStorageService().clearUserName();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );

  }


// Phương thức để kiểm tra các giá trị nhập vào
  Future<bool> checkInputEmail(String email) async{
    // emailError = "";

    if (email.isEmpty ) {
      // kiểm tra định dạng email
      textEmailError = "Email không được để trống!";
      return false;
    }else{
      textEmailError = null;
    }
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(email)) {
      // Kiểm tra định dạng email
      textEmailError = "Email không hợp lệ!";
      return false;
    }else{
      textEmailError = null;
    }
    if (await UserUseCase().checkEmail(email)){
      textEmailError = "Email đã tồn tại!";
      return false;
    }else{
      textEmailError = null;
    }
    return true;
  }

  // Phương thức để kiểm tra các giá trị nhập vào
  bool checkInputPassword(String password) {
    // passwordError = "";
    if (password.isEmpty) {
      // kiểm tra định dạng password
      textPasswordError = "Mật khẩu không được để trống!";
      return false;
    }
    else {
      if (RegExp(r'[A-Z]').hasMatch(password) &&
          RegExp(r'\d').hasMatch(password) &&
          RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
        textPasswordError = null;
        return true;
      }
      else {
        // Kiểm tra có ký tự in hoa
        if (!RegExp(r'[A-Z]').hasMatch(password)) {
          textPasswordError = "$textPasswordError- Mật khẩu phải có ký tự in hoa!\n";
        }

        // Kiểm tra có ký tự số
        if (!RegExp(r'\d').hasMatch(password)) {
          textPasswordError = "$textPasswordError- Mật khẩu phải có ký tự số!\n";
        }

        // Kiểm tra có ký tự đặc biệt
        if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
          textPasswordError = "$textPasswordError- Mật khẩu phải có ký tự đặc biệt!.";
        }
        return false;
      }
    }
  }

  //check confirm password
  bool checkConfirmPass(String pass, String confirm){
    if(pass == confirm){
      confirmError = null;
      return true;
    }
    else{
      confirmError = 'Mật khẩu không khớp!';
      return false;
    }
  }

  // Phương thức để kiểm tra các giá trị nhập vào
  bool checkInputName(String name) {
    // passwordError = "";
    if (name.isEmpty) {
      // kiểm tra định dạng password
      textNameError = "Tên không được để trống!";
      return false;
    }else{
      textNameError = null;
    }
    return true;
  }

  // Phương thức để kiểm tra các giá trị nhập vào
  bool checkInputPhone(String phone) {
    // passwordError = "";
    if (phone.isEmpty) {
      // kiểm tra định dạng password
      textPhoneError = "không được để trống!";
      return false;
    }
    else{
      textPhoneError = null;
    }
    return true;
  }

  // hàm chuyển giao diện khi đủ điều kiện
  Future<void> register(BuildContext context0, String name, String phone, String email, String password, String confirm) async {
    bool checkName = checkInputName(name);
    bool checkPhone = checkInputPhone(phone);
    bool checkEmail = await checkInputEmail(email);
    bool checkPass = checkInputPassword(password);
    bool checkConfirm = checkConfirmPass(password, confirm);

    if (checkName && checkPhone && checkEmail && checkPass  && checkConfirm) {
      UserEntity user = UserEntity(
        name: name,
        password: password,
        phone: phone,
        email: email,
        status: true
      );
      await UserUseCase().addUser(user);
      await createAccountAuthenticated(email: email, password: password);
      Fluttertoast.showToast(
        msg: "tạo tài khoản thành công!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.pop(context0);

    } else {
      Fluttertoast.showToast(
        msg: "tạo tài khoản không thành công!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }

    notifyListeners();
  }
  // hàm này tạm thoời bo, no la reset pass trong casi khac
  Future<void> resetPassword(BuildContext context, String email) async{
    await UserUseCase().resetPassword(context, email);
  }

  Future<void> createAccountAuthenticated({
    required String email,
    required String password
  }) async{
    return await UserUseCase().createAccountAuthenticated(email: email, password: password);
  }

  Future<void> sendPassword(String email) async{
    UserEntity? user = await UserUseCase().getUserByEmail(email);
    String? pass = user?.password;
    await UserUseCase().sendPasswordEmail(email, pass!);
  }

}