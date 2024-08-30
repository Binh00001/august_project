// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/cart/cart_bloc.dart';
import 'package:flutter_project_august/blocs/cart/cart_event.dart';
import 'package:flutter_project_august/blocs/change_password/change_password_bloc.dart';
import 'package:flutter_project_august/blocs/change_password/change_password_event.dart';
import 'package:flutter_project_august/blocs/change_password/change_password_state.dart';
import 'package:flutter_project_august/database/share_preferences_helper.dart';
import 'package:flutter_project_august/models/user_model.dart';
import 'package:flutter_project_august/page/login_page/login_screen.dart';
import 'package:flutter_project_august/utill/app_constants.dart';
import 'package:flutter_project_august/utill/color-theme.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _logout() async {
    BlocProvider.of<CartBloc>(context).add(ClearCart());
    SharedPreferencesHelper.removeApiTokenKey();
    await SharedPreferencesHelper.removeUserInfo();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _showChangePasswordDialog() {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    final GlobalKey<FormState> _formKey =
        GlobalKey<FormState>(); // Create a global key for the form

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from closing on tap outside
      builder: (BuildContext dialogContext) {
        return BlocListener<ChangePasswordBloc, ChangePasswordState>(
          listener: (context, state) {
            if (state is ChangePasswordSuccess) {
              Navigator.pop(dialogContext); // Close the change password dialog
              _showResultDialog(dialogContext, 'Thành công',
                  'Mật khẩu đã được thay đổi thành công!');
            } else if (state is ChangePasswordFailure) {
              // Navigator.pop(dialogContext); // Close the change password dialog
              _showResultDialog(dialogContext, 'Thất bại', state.error);
            }
          },
          child: AlertDialog(
            title: const Text('Đổi mật khẩu'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: currentPasswordController,
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: 'Mật khẩu hiện tại'),
                    validator: (value) => value != null && value.isNotEmpty
                        ? null
                        : 'Vui lòng nhập mật khẩu hiện tại',
                  ),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: 'Mật khẩu mới'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu mới';
                      }
                      if (value.length < 6) {
                        return 'Mật khẩu phải có ít nhất 6 ký tự';
                      }
                      if (value != confirmPasswordController.text) {
                        return 'Mật khẩu xác nhận không khớp';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: 'Xác nhận mật khẩu'),
                    validator: (value) => value == newPasswordController.text
                        ? null
                        : 'Mật khẩu xác nhận không khớp',
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (currentPasswordController.text !=
                        newPasswordController.text) {
                      BlocProvider.of<ChangePasswordBloc>(dialogContext).add(
                          ChangePasswordRequested(
                              oldPassword: currentPasswordController.text,
                              newPassword: newPasswordController.text));
                    } else {
                      _showResultDialog(context, "Thất bại",
                          "Mật khẩu mới phải khác mật khẩu cũ");
                    }
                  }
                },
                child: const Text('Xác nhận'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showResultDialog(BuildContext context, String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the result dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.user == AppConstants.defaultUser) {
      return const Scaffold(
        body: Center(
          child: Text(
              "Lỗi khi tải dữ liệu người dùng"), // Display a loading indicator while user data is loading
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildProfileDetail('Tên người dùng', widget.user.name),
                  _buildProfileDetail('Chức vụ', widget.user.role),
                  if (widget.user.role == 'user')
                    _buildProfileDetail('Trường học', widget.user.schoolName),
                  // const Spacer(),
                  InkWell(
                    onTap: _showChangePasswordDialog,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock_outline,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Đổi mật khẩu',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    height: 20,
                    thickness: 1,
                  ),
                  InkWell(
                    onTap: _logout,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Đăng xuất',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // const SizedBox(height: 4),
                  Divider(
                    color: Colors.grey.shade300,
                    height: 20,
                    thickness: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(color: AppColors.primary),
      child: Column(
        children: [
          const SizedBox(height: 80),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            child: const Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.user.name,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        Divider(
          color: Colors.grey.shade300,
          height: 20,
          thickness: 1,
        ),
      ],
    );
  }
}
