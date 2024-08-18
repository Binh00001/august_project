import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/create_user/create_user_bloc.dart';
import 'package:flutter_project_august/blocs/create_user/create_user_event.dart';
import 'package:flutter_project_august/blocs/create_user/create_user_state.dart';
import 'package:flutter_project_august/blocs/get_all_user/get_all_user_bloc.dart';
import 'package:flutter_project_august/blocs/get_all_user/get_all_user_event.dart';
import 'package:flutter_project_august/blocs/get_all_user/get_all_user_state.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_bloc.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_event.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_state.dart';
import 'package:flutter_project_august/models/school_model.dart';
import 'package:flutter_project_august/models/user_model.dart';
import 'package:flutter_project_august/utill/color-theme.dart';

class UserManagePage extends StatefulWidget {
  @override
  _UserManagePageState createState() => _UserManagePageState();
}

class _UserManagePageState extends State<UserManagePage> {
  String? selectedSchoolId;
  List<School> schools = [];

  @override
  void initState() {
    super.initState();
    _loadSchools();
    // Initially fetch the users
    _loadUser(null);
  }

  void _loadSchools() async {
    BlocProvider.of<SchoolBloc>(context).add(GetAllSchoolsEvent());
  }

  void _loadUser(schoolId) {
    context.read<UserBloc>().add(FetchUsers(schoolId: schoolId));
  }

  void _clearSelection() {
    setState(() {
      selectedSchoolId = null;
      _loadUser(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SchoolBloc, SchoolState>(
      listener: (context, state) {
        if (state is SchoolLoaded) {
          setState(() {
            schools = state.schools; // Update the schools list when loaded
          });
        } else if (state is SchoolError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      child: BlocListener<CreateUserBloc, CreateUserState>(
        listener: (context, state) {
          if (state is CreateUserSuccess) {
            // Show success notification
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Người dùng đã được tạo thành công!')),
            );
            // Optionally reload users after a new user is created
            setState(() {
              selectedSchoolId = null;
            });
            _loadUser(null);
          } else if (state is CreateUserError) {
            // Show error notification
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi: ${state.message}')),
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
              'Người dùng',
              style: TextStyle(fontSize: 20),
            ),
            centerTitle: true,
          ),
          floatingActionButton: addNewUserFloatButton(),
          body: listUser(),
        ),
      ),
    );
  }

  Padding listUser() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: BlocBuilder<SchoolBloc, SchoolState>(
                  builder: (context, state) {
                    if (state is SchoolLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is SchoolLoaded) {
                      return DropdownButtonFormField<String>(
                        value: selectedSchoolId,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedSchoolId =
                                newValue; // Update the selected school ID
                            _loadUser(selectedSchoolId);
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Chọn trường học',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null, // Null value for "All"
                            child: Text("Tất cả"),
                          ),
                          ...state.schools
                              .map<DropdownMenuItem<String>>((School school) {
                            return DropdownMenuItem<String>(
                              value: school.id,
                              child: Text(school.name),
                            );
                          }).toList(),
                        ],
                      );
                    } else if (state is SchoolError) {
                      return Text('Error: ${state.message}');
                    } else {
                      return const Text("Không có dữ liệu trường học");
                    }
                  },
                ),
              ),
              if (selectedSchoolId != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSelection,
                ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UserLoaded) {
                  return ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                      return UserItem(
                        user: user,
                        schools: schools, // Pass the updated schools list
                        index: index,
                      );
                    },
                  );
                } else if (state is UserError) {
                  return const Center(child: Text('Failed to load users'));
                } else {
                  return const Center(child: Text('No users available'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton addNewUserFloatButton() {
    return FloatingActionButton.extended(
      onPressed: _addNewUser,
      label: const Text(
        'Thêm Người Dùng',
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
    );
  }

  void _addNewUser() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? username;
        String? name;
        String? password;
        String? selectedSchool;

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
                  BlocBuilder<SchoolBloc, SchoolState>(
                    builder: (context, state) {
                      if (state is SchoolLoading) {
                        return const CircularProgressIndicator();
                      } else if (state is SchoolLoaded) {
                        return DropdownButtonFormField<String>(
                          value: selectedSchool,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSchool = newValue;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Chọn trường học',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: state.schools
                              .map<DropdownMenuItem<String>>((School school) {
                            return DropdownMenuItem<String>(
                              value: school.id,
                              child: Text(school.name),
                            );
                          }).toList(),
                        );
                      } else if (state is SchoolError) {
                        return Text('Error: ${state.message}');
                      } else {
                        return const Text("Không có dữ liệu trường học");
                      }
                    },
                  ),
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
                  context.read<CreateUserBloc>().add(
                        CreateNewUser(
                          username: username?.trim() ?? "",
                          name: name?.trim() ?? "",
                          password: password?.trim() ?? "",
                          schoolId: selectedSchool!,
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

class UserItem extends StatefulWidget {
  final User user;
  final int index;
  final List<School> schools;

  const UserItem({
    required this.user,
    required this.index,
    required this.schools,
  });

  @override
  _UserItemState createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  bool isExpanded = false;

  String? _getSchoolName(String schoolId) {
    final school = widget.schools.firstWhere(
      (school) => school.id == schoolId,
      orElse: () => School(id: "", name: "Unknown School"),
    );
    return school.name;
  }

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
              Row(
                children: [
                  Text('${widget.index + 1}.'),
                  const SizedBox(width: 8),
                  Text(widget.user.username),
                ],
              ),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tên người dùng: ${widget.user.name}'),
                      Text(
                          'Tên trường: ${_getSchoolName(widget.user.schoolId)}'),
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
