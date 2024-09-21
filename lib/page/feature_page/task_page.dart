import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/assets_widget/school_dropdown.dart';
import 'package:flutter_project_august/blocs/assign_staff/assign_staff_bloc.dart';
import 'package:flutter_project_august/blocs/assign_staff/assign_staff_event.dart';
import 'package:flutter_project_august/blocs/assign_staff/assign_staff_state.dart';
import 'package:flutter_project_august/blocs/get_all_staff/get_all_staff_event.dart';
import 'package:flutter_project_august/blocs/get_all_staff/get_all_staff_state.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_bloc.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_event.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_state.dart';
import 'package:flutter_project_august/blocs/task/task_bloc.dart';
import 'package:flutter_project_august/blocs/task/task_state.dart';
import 'package:flutter_project_august/blocs/task/task_event.dart';
import 'package:flutter_project_august/models/school_model.dart';
import 'package:flutter_project_august/models/task_model.dart';
import 'package:flutter_project_august/models/user_model.dart';
import 'package:flutter_project_august/page/feature_page/history_task.dart';
import 'package:flutter_project_august/utill/app_constants.dart';
import 'package:flutter_project_august/utill/color-theme.dart';

import '../../blocs/get_all_staff/get_all_staff_bloc.dart';

class TaskPage extends StatefulWidget {
  final User user;
  const TaskPage({Key? key, required this.user}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late School selectedSchool;
  String? selectedSchoolId;
  @override
  void initState() {
    super.initState();
    _loadStaff();
    // Get today's date in milliseconds since epoch
    _loadTask();
    BlocProvider.of<SchoolBloc>(context).add(GetAllSchoolsEvent());
  }

  void _loadStaff() {
    context.read<StaffBloc>().add(const FetchStaff());
  }

  void _loadTask() {
    DateTime now = DateTime.now();
    // Set to noon of the current day
    DateTime noon = DateTime(now.year, now.month, now.day, 12, 0, 0);
    // Dispatch the event to fetch tasks for the middle of the day
    if (selectedSchoolId != null && selectedSchoolId != "") {
      context.read<TaskBloc>().add(FetchTasks(
          date: noon.millisecondsSinceEpoch, schoolId: selectedSchoolId!));
    } else {
      context
          .read<TaskBloc>()
          .add(FetchTasks(date: noon.millisecondsSinceEpoch, schoolId: ""));
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
        title: const Text('Phân công mua'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        // actions: [
        //   if (widget.user.role == 'admin')
        //     IconButton(
        //       icon: const Icon(Icons.history),
        //       onPressed: () async {
        //         // Navigate to the history page
        //         await Navigator.of(context).push(
        //           MaterialPageRoute(
        //             builder: (context) =>
        //                 const HistoryPage(), // Replace with your history page
        //           ),
        //         );
        //         _loadTask();
        //       },
        //     ),
        // ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 16,
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
                          _loadTask();
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
          BlocListener<AssignStaffBloc, AssignStaffState>(
              listener: (context, state) {
                if (state is AssignStaffSuccess) {
                  _loadTask();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chỉ định thành công!')),
                  );
                } else if (state is AssignStaffFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: ${state.error}')),
                  );
                }
              },
              child: selectedSchoolId == null
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
                                        if (widget.user.role == 'admin')
                                          IconButton(
                                            icon: const Icon(Icons
                                                .settings), // Settings icon
                                            onPressed: () {
                                              // Implement settings action here
                                              _showAssignStaffDialog(
                                                  context, selectedSchoolId!);
                                            },
                                          ),
                                      ],
                                    )),
                              ),

                              // Task List Display or Empty Message
                              state.tasks.isEmpty
                                  ? const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                            'Không có hàng hoá nào cần mua.'),
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
                    ))
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

  void _showAssignStaffDialog(BuildContext context, String schoolId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: BlocBuilder<StaffBloc, StaffState>(
              builder: (context, state) {
                if (state is StaffLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is StaffLoaded) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Chọn nhân viên',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 240,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics:
                                const AlwaysScrollableScrollPhysics(), // Ensure the list is scrollable
                            itemCount: state.staff.length,
                            itemBuilder: (context, index) {
                              final staff = state.staff[index];
                              return Container(
                                margin: const EdgeInsets.only(top: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.onPrimary,
                                  border: Border.all(
                                      color: Colors.grey, width: 2.0),
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Rounded corners
                                ),
                                child: ListTile(
                                  title: Text(
                                    staff.name,
                                  ),
                                  trailing: Container(
                                    width:
                                        24, // Width of the circular container
                                    height:
                                        24, // Height of the circular container
                                    decoration: const BoxDecoration(
                                      color: AppColors
                                          .lightRed, // Background color of the circle
                                      shape: BoxShape
                                          .circle, // Make the container circular
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors
                                          .white, // Color of the plus icon
                                      size: 16, // Size of the plus icon
                                    ),
                                  ),
                                  onTap: () {
                                    // Assign the selected staff to the task
                                    BlocProvider.of<AssignStaffBloc>(context)
                                        .add(
                                      AssignStaffToTaskEvent(
                                          userId: staff.id, schoolId: schoolId),
                                    );
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (state is StaffError) {
                  return Center(
                    child: Text('Lỗi: ${state.message}'),
                  );
                } else {
                  return const Center(child: Text('Không có nhân viên nào.'));
                }
              },
            ));
      },
    );
  }
}
