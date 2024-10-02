import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/create_school/create_school_bloc.dart';
import 'package:flutter_project_august/blocs/create_school/create_school_event.dart';
import 'package:flutter_project_august/blocs/create_school/create_school_state.dart';
import 'package:flutter_project_august/blocs/delete_school/delete_school_bloc.dart';
import 'package:flutter_project_august/blocs/delete_school/delete_school_event.dart';
import 'package:flutter_project_august/blocs/delete_school/delete_school_state.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_bloc.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_event.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_state.dart';
import 'package:flutter_project_august/models/school_model.dart';
import 'package:flutter_project_august/utill/color-theme.dart';
import 'package:flutter/services.dart';

class SchoolManageScreen extends StatefulWidget {
  const SchoolManageScreen({super.key});

  @override
  _SchoolManageScreenState createState() => _SchoolManageScreenState();
}

class _SchoolManageScreenState extends State<SchoolManageScreen> {
  List<School> schools = [];

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
          BlocListener<SchoolDeleteBloc, SchoolDeleteState>(
            listener: (context, state) {
              if (state is SchoolDeleteLoading) {
                _showLoadingDialog(); // Show a loading indicator while deletion is in progress
              } else if (state is SchoolDeleteSuccess) {
                Navigator.of(context).pop(); // Dismiss loading dialog if any
                _showMessageDialog(
                    'Thành công', 'Trường đã được xoá thành công.');
                BlocProvider.of<SchoolBloc>(context)
                    .add(GetAllSchoolsEvent()); // Refresh the list
              } else if (state is SchoolDeleteFailure) {
                Navigator.of(context).pop(); // Dismiss loading dialog if any
                _showMessageDialog(
                    'Thất bại', state.error); // Show error message
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
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: ExpansionTile(
                  title: Text(
                    '${index + 1}. ${schools[index].name}',
                    style: const TextStyle(
                      overflow: TextOverflow
                          .ellipsis, // Automatically add ellipses if text is too long
                    ),
                  ),
                  children: <Widget>[
                    ListTile(
                      title: const Text('Địa chỉ'),
                      subtitle: Text(
                        schools[index].address != "null"
                            ? schools[index].address!
                            : 'Không có',
                        style: const TextStyle(
                          overflow: TextOverflow
                              .ellipsis, // Automatically add ellipses if text is too long
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text('Điện thoại'),
                      subtitle: Text(
                        schools[index].phoneNumber != "null"
                            ? schools[index].phoneNumber!
                            : 'Không có',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          // Handle the delete action here, e.g., show delete confirmation dialog
                          _showDeleteConfirmationDialog(
                              context, schools[index].id);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color:
                                Colors.red, // Red background for delete button
                            borderRadius:
                                BorderRadius.circular(4), // Rounded corners
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Xoá trường',
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

  void _showDeleteConfirmationDialog(BuildContext context, String schoolId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cảnh báo'),
          content: const Text(
              'Trường bị xoá sẽ không thể khôi phục, bạn có muốn tiếp tục?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // White text color
                backgroundColor: Colors.red, // Red background for danger
              ),
              child: const Text('Tiếp tục'),
              onPressed: () {
                Navigator.of(context).pop();
                BlocProvider.of<SchoolDeleteBloc>(context)
                    .add(DeleteSchoolEvent(schoolId: schoolId));
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
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ],
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
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                              10), // Limit to 10 characters
                        ],
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
