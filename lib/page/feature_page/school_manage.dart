import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return SafeArea(
      child: Scaffold(
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
        body: BlocConsumer<SchoolBloc, SchoolState>(
          listener: (context, state) {
            if (state is SchoolLoaded) {
              setState(() {
                schools = state.schools;
              });
            } else if (state is SchoolError) {
              _loadSchoolsFromLocal();
            }
          },
          builder: (context, state) {
            return Padding(
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
                        subtitle:
                            Text(schools[index]['phoneNumber'] ?? 'Không có'),
                      ),
                    ],
                  );
                },
              ),
            );
          },
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
      ),
    );
  }

  void _addNewSchool() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? name;
        String? address;
        String? phoneNumber;
        return AlertDialog(
          title: const Text('Nhập Thông Tin'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Tên Trường'),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Địa Chỉ'),
                  onChanged: (value) {
                    address = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Số Điện Thoại'),
                  onChanged: (value) {
                    phoneNumber = value;
                  },
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
                if (name != null && name!.isNotEmpty) {
                  setState(() {
                    schools.add({
                      'name': name,
                      'address': address,
                      'phoneNumber': phoneNumber
                    });
                  });
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
}
