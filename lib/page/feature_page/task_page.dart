import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/assign_staff/assign_staff_bloc.dart';
import 'package:flutter_project_august/blocs/assign_staff/assign_staff_event.dart';
import 'package:flutter_project_august/blocs/assign_staff/assign_staff_state.dart';
import 'package:flutter_project_august/blocs/get_all_staff/get_all_staff_event.dart';
import 'package:flutter_project_august/blocs/get_all_staff/get_all_staff_state.dart';
import 'package:flutter_project_august/blocs/task/task_bloc.dart';
import 'package:flutter_project_august/blocs/task/task_state.dart';
import 'package:flutter_project_august/blocs/task/task_event.dart';
import 'package:flutter_project_august/models/task_model.dart';
import 'package:flutter_project_august/models/user_model.dart';
import 'package:flutter_project_august/page/feature_page/history_task.dart';
import 'package:flutter_project_august/utill/color-theme.dart';

import '../../blocs/get_all_staff/get_all_staff_bloc.dart';

class TaskPage extends StatefulWidget {
  final User user;
  const TaskPage({Key? key, required this.user}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    super.initState();
    _loadStaff();
    // Get today's date in milliseconds since epoch
    _loadTask();
  }

  void _loadStaff() {
    context.read<StaffBloc>().add(const FetchStaff());
  }

  void _loadTask() {
    DateTime now = DateTime.now();
    // Set to noon of the current day
    DateTime noon = DateTime(now.year, now.month, now.day, 12, 0, 0);
    // Dispatch the event to fetch tasks for the middle of the day
    context.read<TaskBloc>().add(FetchTasks(date: noon.millisecondsSinceEpoch));
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
        actions: [
          if (widget.user.role == 'admin')
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () async {
                // Navigate to the history page
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        const HistoryPage(), // Replace with your history page
                  ),
                );
                _loadTask();
              },
            ),
        ],
      ),
      body: BlocListener<AssignStaffBloc, AssignStaffState>(
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
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskLoaded) {
              if (state.tasks.isEmpty) {
                return const Center(
                    child: Text('Không có hàng hoá nào cần mua.'));
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children:
                      state.tasks.map((task) => _buildTaskItem(task)).toList(),
                ),
              );
            } else if (state is TaskError) {
              return Center(
                child: Text('Lỗi: ${state.message}'),
              );
            } else {
              return const Center(child: Text('Không có nhiệm vụ nào.'));
            }
          },
        ),
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
          Column(
            children: [
              if (widget.user.role == 'admin') ...[
                if (task.staff == null)
                  GestureDetector(
                    onTap: () {
                      _showAssignStaffDialog(context, task);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0), // Padding inside the container
                      decoration: BoxDecoration(
                        color: AppColors.lightRed, // Background color
                        border: Border.all(
                            color: Colors.red, width: 1.0), // Red border
                        borderRadius:
                            BorderRadius.circular(4.0), // Rounded corners
                      ),
                      child: const Text(
                        'Phân công', // The text inside the container
                        style: TextStyle(
                          color: Colors.white, // White text color
                          fontSize: 14.0, // Font size
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                    ),
                  )
                else ...[
                  const Icon(Icons.person_4, color: AppColors.onSuccess),
                  Text(
                    task.staff!.name, // Assuming 'staff' has a 'name' field
                    // "name",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ]
              ] else if (widget.user.role == 'staff' && task.staff != null) ...[
                if (task.staff!.id == widget.user.id) ...[
                  Row(
                    children: [
                      const Icon(Icons.person_4, color: Colors.blue),
                      Text(
                        task.staff!.name, // Assuming 'staff' has a 'name' field
                        style: const TextStyle(
                          color: Colors.blue, // Highlighted text color
                          fontSize: 16, // Slightly larger font size
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                    ],
                  ), // Highlighted icon
                ] else ...[
                  Row(
                    children: [
                      const Icon(Icons.person_4, color: AppColors.onSuccess),
                      Text(
                        task.staff!.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ]
              ]
            ],
          ),
        ],
      ),
    );
  }

  void _showAssignStaffDialog(BuildContext context, Task task) {
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
                          height: 400, // Set maximum height to 500px
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
                                          userId: staff.id, productId: task.id),
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
