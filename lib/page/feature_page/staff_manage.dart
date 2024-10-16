import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/create_staff/create_staff_bloc.dart';
import 'package:flutter_project_august/blocs/create_staff/create_staff_event.dart';
import 'package:flutter_project_august/blocs/create_staff/create_staff_state.dart';
import 'package:flutter_project_august/blocs/delete_user_or_staff/delete_user_bloc.dart';
import 'package:flutter_project_august/blocs/delete_user_or_staff/delete_user_event.dart';
import 'package:flutter_project_august/blocs/delete_user_or_staff/delete_user_state.dart';
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
          _loadStaff(null);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Người dùng đã được tạo thành công!')),
          );
        } else if (state is CreateStaffError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${state.error}')),
          );
        }
      },
      child: BlocListener<UserDeleteBloc, UserDeleteState>(
        listener: (context, state) {
          if (state is UserDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Người dùng đã bị xoá thành công!')),
            );
            // Optionally reload the staff list after a user is deleted
            _loadStaff(null);
          } else if (state is UserDeleteFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi khi xoá người dùng: ${state.error}')),
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
        String? confirmPassword;

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
                      if (value.length < 6) {
                        return 'Mật khẩu phải có ít nhất 6 ký tự';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Xác nhận mật khẩu',
                      hintText: 'Nhập lại mật khẩu',
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
                      confirmPassword = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bắt buộc';
                      }
                      if (value != password) {
                        return 'Mật khẩu không khớp';
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
  // final Function onDelete; // Callback to handle delete action

  const StaffItem({
    super.key,
    required this.user,
    required this.index,
    // required this.onDelete, // Pass the delete callback function
  });

  @override
  _StaffItemState createState() => _StaffItemState();
}

class _StaffItemState extends State<StaffItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 8), // Consistent margin as SchoolItem
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0), // Grey border
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      child: ExpansionTile(
        title: Text(
          '${widget.index + 1}. ${widget.user.username}',
          style: const TextStyle(
            overflow: TextOverflow.ellipsis, // Ellipsis for long text
          ),
        ),
        children: <Widget>[
          ListTile(
            title: const Text('Tên người dùng'),
            subtitle: Text(
              widget.user.name,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis, // Prevent text overflow
              ),
            ),
          ),
          const ListTile(
            title: Text('Vị trí'),
            subtitle: Text('Nhân viên'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                // Handle the tap action here, e.g., show the delete confirmation dialog
                _showDeleteConfirmationDialog(context, widget.user.id);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.red, // Red background
                  borderRadius: BorderRadius.circular(4), // Rounded corners
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Xoá nhân viên',
                      style: TextStyle(
                        color: Colors.white, // White text color
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String staffId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cảnh báo'),
          content: const Text(
              'Nhân viên bị xoá sẽ không thể khôi phục, bạn có muốn tiếp tục?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // White text color
                backgroundColor: Colors.red, // Red background for danger
              ),
              child: const Text('Tiếp tục'),
              onPressed: () {
                Navigator.of(context).pop();
                BlocProvider.of<UserDeleteBloc>(context)
                    .add(DeleteUserEvent(userId: staffId));
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // Black text color
                backgroundColor: Colors.grey[300], // Grey background for cancel
              ),
              child: const Text('Không'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
