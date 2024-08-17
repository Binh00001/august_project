// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_august/database/share_preferences_helper.dart';
import 'package:flutter_project_august/page/main_page/main_screen.dart';
import 'package:flutter_project_august/repo/auth_repo.dart';
import 'package:flutter_project_august/utill/color-theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthRepo authRepo =
      AuthRepositoryImpl(Dio()); // Khai báo biến để giữ thể hiện của AuthRepo

  // _LoginPageState()
  //     : authRepo = AuthRepositoryImpl(Dio()); // Khởi tạo thể hiện của AuthRepo

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _login() async {
    var username = emailController.text.trim();
    var password = passwordController.text.trim();
    var result = await authRepo.signIn(username, password);
    if (result["success"]) {
      //lưu token
      SharedPreferencesHelper.setApiTokenKey(result['data']['accessToken']);
      //chuyển trang
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng nhập thất bại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đăng Nhập"),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Tên đăng nhập"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Hãy nhập tên đăng nhập';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Mật khẩu"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Hãy nhập mật khẩu';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Hãy điền đầy đủ thông tin')),
                        );
                        return;
                      }
                      _login();
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //       content: Text('Sai tài khoản hoặc mật khẩu')),
                      // );
                      return;
                    },
                    child: const Text('Đăng nhập'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
