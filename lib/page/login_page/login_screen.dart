import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_august/database/share_preferences_helper.dart';
import 'package:flutter_project_august/models/user_model.dart';
import 'package:flutter_project_august/page/main_page/main_screen.dart';
import 'package:flutter_project_august/repo/auth_repo.dart';
import 'package:flutter_project_august/utill/color-theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthRepo authRepo = AuthRepositoryImpl(Dio());
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false; // Track loading state

  void _login() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    var username = emailController.text.trim();
    var password = passwordController.text.trim();
    var result = await authRepo.signIn(username, password);

    setState(() {
      _isLoading = false; // Hide loading indicator
    });

    if (result["success"]) {
      SharedPreferencesHelper.setApiTokenKey(result['data']['accessToken']);
      var userData = result['data']['user'];
      User user = User.fromJson(userData);
      await SharedPreferencesHelper.setUserInfo(user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng nhập thất bại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng Nhập"),
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
                  child: _isLoading
                      ? const CircularProgressIndicator() // Show loading indicator
                      : ElevatedButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Hãy điền đầy đủ thông tin')),
                              );
                              return;
                            }
                            _login();
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
