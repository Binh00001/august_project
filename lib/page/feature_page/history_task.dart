import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/assets_widget/school_dropdown.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_bloc.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_state.dart';
import 'package:flutter_project_august/blocs/task/task_bloc.dart';
import 'package:flutter_project_august/blocs/task/task_state.dart';
import 'package:flutter_project_august/blocs/task/task_event.dart';
import 'package:flutter_project_august/models/task_model.dart';
import 'package:flutter_project_august/utill/app_constants.dart';
import 'package:flutter_project_august/utill/color-theme.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late DateTime selectedDate;
  String? selectedSchoolId;
  @override
  void initState() {
    super.initState();
    // Set default date to today
    DateTime now = DateTime.now();
    selectedDate = DateTime(now.year, now.month, now.day, 12, 0, 0);

    _fetchTasksForSelectedDate();
  }

  void _fetchTasksForSelectedDate() {
    // Dispatch the event to fetch tasks for the selected date
    // context
    //     .read<TaskBloc>()
    //     .add(FetchTasks(date: selectedDate.millisecondsSinceEpoch));
    if (selectedSchoolId != null && selectedSchoolId != "") {
      context.read<TaskBloc>().add(FetchTasks(
          date: selectedDate.millisecondsSinceEpoch,
          schoolId: selectedSchoolId!));
    } else {
      context.read<TaskBloc>().add(
          FetchTasks(date: selectedDate.millisecondsSinceEpoch, schoolId: ""));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020), // Earliest date allowed
      lastDate: DateTime.now(), // Latest date allowed is today
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      // Adjust pickedDate to be at noon of the selected day
      DateTime noonDate =
          DateTime(pickedDate.year, pickedDate.month, pickedDate.day, 12, 0, 0);
      setState(() {
        selectedDate = noonDate;
      });
      _fetchTasksForSelectedDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Lịch sử phân công'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Ngày: ${DateFormat('dd/MM/yyyy').format(selectedDate)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: BlocBuilder<SchoolBloc, SchoolState>(
              builder: (context, state) {
                if (state is SchoolLoading) {
                  return const CircularProgressIndicator();
                } else if (state is SchoolLoaded) {
                  return SchoolDropdown(
                    selectedSchoolId: selectedSchoolId,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSchoolId = newValue;
                        if (selectedSchoolId != null) {
                          //fetch task only if a school is selected
                          _fetchTasksForSelectedDate();
                        }
                      });
                    },
                    schools: state.schools,
                  );
                } else if (state is SchoolError) {
                  return Text('Error: ${state.message}');
                } else {
                  return const Text("Không có dữ liệu trường học");
                }
              },
            ),
          ),
          selectedSchoolId == null
              ? const Expanded(
                  child: Center(
                    child: Text('Hãy chọn trường để xem chi tiết'),
                  ),
                )
              : BlocBuilder<TaskBloc, TaskState>(
                  builder: (context, state) {
                    if (state is TaskLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is TaskLoaded) {
                      // Check if staff is different from default
                      bool isStaffDifferent =
                          state.staff != AppConstants.defaultStaff;
                      return Column(
                        children: [
                          // Always display the staff info
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 12,
                              left: 8,
                              right: 8,
                              bottom: 8,
                            ),
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                decoration: BoxDecoration(
                                  color: isStaffDifferent
                                      ? AppColors.primary.withOpacity(
                                          0.3) // Original background when staff is assigned
                                      : Colors.red.withOpacity(
                                          0.3), // Red background for "Phân công nhân viên"
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      isStaffDifferent
                                          ? 'Nhân viên: ${state.staff.name}' // Display staff's name
                                          : 'Chưa phân công', // Default text if no staff assigned
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    // Check if the current user is an admin
                                  ],
                                )),
                          ),

                          // Task List Display or Empty Message
                          state.tasks.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child:
                                        Text('Không có hàng hoá nào cần mua.'),
                                  ),
                                )
                              : SingleChildScrollView(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    children: state.tasks
                                        .map((task) => _buildTaskItem(task))
                                        .toList(),
                                  ),
                                ),
                        ],
                      );
                    } else if (state is TaskError) {
                      return Center(
                        child: Text('Lỗi: ${state.message}'),
                      );
                    } else {
                      return const Center(
                        child: Text('Không có nhiệm vụ nào.'),
                      );
                    }
                  },
                )
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              Text(
                '${task.quantity} ${task.unit}',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
