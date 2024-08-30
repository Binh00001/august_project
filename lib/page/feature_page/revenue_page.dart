import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/get_revenue/revenue_bloc.dart';
import 'package:flutter_project_august/blocs/get_revenue/revenue_event.dart';
import 'package:flutter_project_august/utill/color-theme.dart';

class RevenuePage extends StatefulWidget {
  @override
  _RevenuePageState createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> {
  int? selectedYear;
  List<int> yearOptions = [];

  @override
  void initState() {
    super.initState();
    // Calculate year options
    int currentYear = DateTime.now().year;
    for (int i = currentYear - 10; i <= currentYear + 10; i++) {
      yearOptions.add(i);
    }
    selectedYear = currentYear; // Set the current year as default
    // Load initial revenue data for the current year
    // You might want to trigger an event to your BLoC here if your data depends on the year
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doanh thu'),
        backgroundColor:
            AppColors.primary, // Assuming AppColors.primary is blue
        foregroundColor:
            AppColors.onPrimary, // Assuming AppColors.onPrimary is white
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Doanh thu năm: "),
                  ],
                ),
                SizedBox(width: 80, child: _buildYearDropdown()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearDropdown() {
    return DropdownButton<int>(
      menuMaxHeight: 180,
      value: selectedYear,
      onChanged: (int? newValue) {
        setState(() {
          selectedYear = newValue;
        });
        BlocProvider.of<RevenueBloc>(context)
            .add(LoadRevenues(year: newValue ?? DateTime.now().year));
        // Trigger a BLoC event to fetch data for the selected year
      },
      items: yearOptions.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      underline: Container(
        height: 0, // Removes underline
      ),
      icon: const Icon(Icons.arrow_downward, size: 16), // Smaller icon size

      isExpanded:
          true, // Ensures the dropdown is as wide as the parent container
      dropdownColor: Colors.white,
    );
  }
}
