import 'package:caccu_app/presentation/Screen/Register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'UserViewModel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController textEmail = TextEditingController();
  TextEditingController textPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Lắng nghe UserViewModel để cập nhật UI khi có thay đổi
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Consumer<UserViewModel>(
            builder: (context, userViewModel, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 120),
                  // Hình ảnh minh họa
                  Image.asset(
                    'lib/img/logo.webp', // Thay đổi đường dẫn hình ảnh của bạn
                    height: 250,
                  ),
                  SizedBox(height: 20),
                  // Tiêu đề đăng nhập
                  const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  // Trường Email
                  TextField(
                    controller: textEmail,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Johndoe@exemple.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorText: userViewModel.emailError, // Sửa lỗi ở đây
                    ),
                  ),
                  SizedBox(height: 20),
                  // Trường Mật khẩu
                  TextField(
                    controller: textPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorText: userViewModel.passwordError, // Sửa lỗi ở đây
                    ),
                  ),
                  SizedBox(height: 30),
                  // Nút đăng nhập
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<UserViewModel>(context, listen: false).nextScreen(
                        context,
                        textEmail.text, // Lấy giá trị từ TextEditingController thay vì toString()
                        textPassword.text,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Log in',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Đăng nhập bằng các phương thức khác
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Log in with '),
                      IconButton(
                        icon: Icon(Icons.email, color: Colors.red), // Google icon placeholder
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.facebook, color: Colors.blue), // Facebook icon placeholder
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.code, color: Colors.black), // GitHub icon placeholder
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Liên kết đến trang đăng ký
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No account? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
