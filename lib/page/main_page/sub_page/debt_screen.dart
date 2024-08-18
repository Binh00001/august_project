import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/get_debt/get_debt_bloc.dart';
import 'package:flutter_project_august/blocs/get_debt/get_debt_event.dart';
import 'package:flutter_project_august/blocs/get_debt/get_debt_state.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_bloc.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_event.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_state.dart';
import 'package:flutter_project_august/database/share_preferences_helper.dart';
import 'package:flutter_project_august/models/school_model.dart';
import 'package:flutter_project_august/models/user_model.dart';
import 'package:flutter_project_august/utill/color-theme.dart';
import 'package:intl/intl.dart';

class DebtScreen extends StatefulWidget {
  @override
  _DebtScreenState createState() => _DebtScreenState();
}

class _DebtScreenState extends State<DebtScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _dateError = '';
  String? selectedSchoolId;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      _user = await SharedPreferencesHelper.getUserInfo();
      if (_user != null) {
        setState(() {});
        if (_user!.role == 'admin') {
          // Fetch the list of schools only if the user is an admin
          BlocProvider.of<SchoolBloc>(context).add(GetAllSchoolsEvent());
          // Fetch Debt without specifying a school
          BlocProvider.of<DebtBloc>(context).add(FetchDebt());
        } else if (_user!.role == 'user') {
          // If the user is a regular user, fetch the debt for their school
          BlocProvider.of<DebtBloc>(context).add(FetchDebt(
            schoolId: _user!.schoolId,
          ));
        }
      } else {
        print('User is null');
      }
    } catch (e) {
      print('Error loading user info: $e');
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
            _dateError = 'Ngày kết thúc phải sau ngày bắt đầu';
          }
        } else {
          if (_startDate != null && picked.isBefore(_startDate!)) {
            _dateError = 'Ngày kết thúc phải sau ngày bắt đầu';
            return;
          }
          _dateError = "";
          _endDate = picked;
        }

        // Check if both dates are selected before fetching data
        if (_startDate != null && _endDate != null) {
          BlocProvider.of<DebtBloc>(context).add(FetchDebt(
              startDate: _startDate!.millisecondsSinceEpoch,
              endDate: _endDate!.millisecondsSinceEpoch,
              schoolId: selectedSchoolId));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(
        body: const Center(
          child:
              CircularProgressIndicator(), // Display a loading indicator while user data is loading
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Công nợ'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _startDate == null
                            ? 'Từ ngày'
                            : DateFormat('dd/MM/yyyy').format(_startDate!),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _endDate == null
                            ? 'Đến ngày'
                            : DateFormat('dd/MM/yyyy').format(_endDate!),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_dateError.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _dateError,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            const SizedBox(height: 16),
            if (_user!.role == 'admin') ...[
              BlocBuilder<SchoolBloc, SchoolState>(
                builder: (context, state) {
                  if (state is SchoolLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is SchoolLoaded) {
                    return DropdownButtonFormField<String>(
                      value: selectedSchoolId,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSchoolId = newValue;
                          fetchDebtIfPossible(context);
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
                          value: null,
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
            ],
            const Spacer(),
            BlocBuilder<DebtBloc, DebtState>(
              builder: (context, state) {
                if (state is DebtLoaded) {
                  String formattedDebt =
                      NumberFormat('#,##0', 'vi_VN').format(state.debts);

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tổng nợ:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$formattedDebt đ',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                } else if (state is DebtLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const Text("Không có thông tin nợ");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void fetchDebtIfPossible(BuildContext context) {
    if (_startDate != null && _endDate != null) {
      BlocProvider.of<DebtBloc>(context).add(FetchDebt(
          startDate: _startDate!.millisecondsSinceEpoch,
          endDate: _endDate!.millisecondsSinceEpoch,
          schoolId: selectedSchoolId));
    } else {
      BlocProvider.of<DebtBloc>(context)
          .add(FetchDebt(schoolId: selectedSchoolId));
    }
  }
}
