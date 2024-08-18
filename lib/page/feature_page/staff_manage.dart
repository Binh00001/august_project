import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/create_staff/create_staff_bloc.dart';
import 'package:flutter_project_august/blocs/create_staff/create_staff_event.dart';
import 'package:flutter_project_august/blocs/create_staff/create_staff_state.dart';
import 'package:flutter_project_august/blocs/get_all_staff/get_all_staff_bloc.dart';
import 'package:flutter_project_august/blocs/get_all_staff/get_all_staff_event.dart';
import 'package:flutter_project_august/blocs/get_all_staff/get_all_staff_state.dart';
import 'package:flutter_project_august/models/staff_model.dart';
import 'package:flutter_project_august/utill/color-theme.dart';

class StaffManagePage extends StatefulWidget {
  @override
  _StaffManagePageState createState() => _StaffManagePageState();
}

class _StaffManagePageState extends State<StaffManagePage> {
  @override
  void initState() {
    super.initState();
    _loadStaff(null);
  }

  void _loadStaff(schoolId) {
    context.read<StaffBloc>().add(const FetchStaff());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateStaffBloc, CreateStaffState>(
      listener: (context, state) {
        if (state is CreateStaffSuccess) {
          // Show success notification
          _loadStaff(null);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Người dùng đã được tạo thành công!')),
          );
        } else if (state is CreateStaffError) {
          // Show error notification
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lỗi: Không tạo được tài khoản')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          title: const Text(
            'Nhân viên',
            style: TextStyle(fontSize: 20),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _addNewStaff,
          label: const Text(
            'Thêm Nhân Viên',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          icon: const Icon(Icons.add),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<StaffBloc, StaffState>(
                  builder: (context, state) {
                    if (state is StaffLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is StaffLoaded) {
                      return ListView.builder(
                        itemCount: state.staff.length,
                        itemBuilder: (context, index) {
                          final user = state.staff[index];
                          return StaffItem(
                            user: user,
                            index: index,
                          );
                        },
                      );
                    } else if (state is StaffError) {
                      return const Center(
                          child: Text('Tải thông tin thất bại'));
                    } else {
                      return const Center(child: Text('Không có người dùng'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addNewStaff() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? username;
        String? name;
        String? password;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: const Text('Nhập Thông Tin Người Dùng'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Tên đăng nhập',
                      hintText: 'Nhập tên đăng nhập',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      username = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bắt buộc';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Tên người dùng',
                      hintText: 'Nhập tên người dùng',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      name = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bắt buộc';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      hintText: 'Nhập mật khẩu',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      password = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bắt buộc';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Lưu'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<CreateStaffBloc>().add(
                        CreateStaffRequested(
                          username: username!.trim(),
                          name: name!.trim(),
                          password: password!.trim(),
                        ),
                      );

                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class StaffItem extends StatefulWidget {
  final Staff user;
  final int index;
  const StaffItem({required this.user, required this.index});

  @override
  _StaffItemState createState() => _StaffItemState();
}

class _StaffItemState extends State<StaffItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey, // Set the border color to gray
            width: 1.0, // Set the border width
          ),
          borderRadius:
              BorderRadius.circular(4.0), // Set the border radius to 4
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Text('${widget.index + 1}.'),
                    const SizedBox(width: 8),
                    Text(widget.user.username),
                  ],
                ),
              ),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tên người dùng: ${widget.user.name}'),
                      const Text('Nhân viên'),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
