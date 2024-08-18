import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/task/task_bloc.dart';
import 'package:flutter_project_august/blocs/task/task_state.dart';
import 'package:flutter_project_august/blocs/task/task_event.dart';
import 'package:flutter_project_august/models/task_model.dart';
import 'package:flutter_project_august/utill/color-theme.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    // Set default date to today
    selectedDate = DateTime.now();
    _fetchTasksForSelectedDate();
  }

  void _fetchTasksForSelectedDate() {
    // Dispatch the event to fetch tasks for the selected date
    context
        .read<TaskBloc>()
        .add(FetchTasks(date: selectedDate.millisecondsSinceEpoch));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020), // Earliest date allowed
      lastDate: DateTime.now(), // Latest date allowed is today
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
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
          GestureDetector(
            onTap: () => {_selectDate(context)},
            child: Padding(
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
          ),
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TaskLoaded) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: state.tasks
                          .map((task) => _buildTaskItem(task))
                          .toList(),
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
          Column(
            children: [
              if (task.staff == null)
                const Text(
                  'Chưa phân công',
                  style: TextStyle(
                    color: Colors.red, // Red text color
                    fontSize: 16, // Font size
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                )
              else ...[
                const Icon(Icons.person_4, color: AppColors.onSuccess),
                Text(
                  task.staff!.name, // Assuming 'staff' has a 'name' field
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
