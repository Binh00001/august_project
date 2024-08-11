import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/create_school/create_school_bloc.dart';
import 'package:flutter_project_august/blocs/create_school/create_school_event.dart';
import 'package:flutter_project_august/blocs/create_school/create_school_state.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_bloc.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_event.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_state.dart';
import 'package:flutter_project_august/database/local_database.dart';
import 'package:flutter_project_august/utill/color-theme.dart';

class SchoolManageScreen extends StatefulWidget {
  const SchoolManageScreen({super.key});

  @override
  _SchoolManageScreenState createState() => _SchoolManageScreenState();
}

class _SchoolManageScreenState extends State<SchoolManageScreen> {
  List<Map<String, dynamic>> schools = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SchoolBloc>(context).add(GetAllSchoolsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: Text('Quản Lý Trường Học(${schools.length})'),
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SchoolBloc, SchoolState>(
            listener: (context, state) {
              if (state is SchoolLoaded) {
                setState(() {
                  schools = state.schools;
                });
              } else if (state is SchoolError) {
                _loadSchoolsFromLocal();
              }
            },
          ),
          BlocListener<CreateSchoolBloc, CreateSchoolState>(
            listener: (context, state) {
              if (state is CreateSchoolLoading) {
                _showLoadingDialog();
              } else if (state is CreateSchoolSuccess) {
                Navigator.of(context).pop(); // Dismiss loading dialog
                _showMessageDialog('Thành công', state.message);
                BlocProvider.of<SchoolBloc>(context).add(GetAllSchoolsEvent());
              } else if (state is CreateSchoolFailure) {
                Navigator.of(context).pop(); // Dismiss loading dialog
                _showMessageDialog('Thất bại', state.error);
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: schools.length + 1,
            itemBuilder: (context, index) {
              if (index == schools.length) {
                return const SizedBox(height: 240);
              }
              return ExpansionTile(
                title: Text('${index + 1}. ${schools[index]['name']}'),
                children: <Widget>[
                  ListTile(
                    title: const Text('Địa chỉ'),
                    subtitle: Text(schools[index]['address'] ?? 'Không có'),
                  ),
                  ListTile(
                    title: const Text('Điện thoại'),
                    subtitle: Text(schools[index]['phoneNumber'] ?? 'Không có'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewSchool,
        label: const Text(
          'Thêm Trường Mới',
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
    );
  }

  void _addNewSchool() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? name;
        String? address;
        String? phoneNumber;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: const Text('Nhập Thông Tin'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Tên Trường',
                          hintText: 'Nhập tên của trường',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 2),
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
                          labelText: 'Địa chỉ',
                          hintText: 'Nhập địa chỉ',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) => address = value,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Số điện thoại',
                          hintText: 'Nhập số điện thoại',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) => phoneNumber = value,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Lưu'),
              onPressed: () {
                if (name != null && name!.trim().isNotEmpty) {
                  context.read<CreateSchoolBloc>().add(
                        CreateSchool(
                          name: name!.trim(),
                          address: (address ?? "").trim(),
                          contactNumber: (phoneNumber ?? "").trim(),
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

  void _loadSchoolsFromLocal() async {
    final dbSchools = await LocalDatabase.instance.getAllSchools();
    setState(() {
      schools = dbSchools;
    });
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _showMessageDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
