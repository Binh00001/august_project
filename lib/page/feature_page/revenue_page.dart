import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/assets_widget/bar_chart.dart';
import 'package:flutter_project_august/blocs/get_revenue/revenue_bloc.dart';
import 'package:flutter_project_august/blocs/get_revenue/revenue_event.dart';
import 'package:flutter_project_august/blocs/get_revenue/revenue_state.dart';
import 'package:flutter_project_august/models/revenue_model.dart';
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
    for (int i = currentYear - 5; i <= currentYear + 5; i++) {
      yearOptions.add(i);
    }
    selectedYear = currentYear; // Set the current year as default
    // Load initial revenue data for the current year
    BlocProvider.of<RevenueBloc>(context).add(LoadRevenues(year: currentYear));
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
                const Text("Doanh thu năm:      "),
                SizedBox(width: 80, child: _buildYearDropdown()),
              ],
            ),
          ),
          // Within the RevenuePage class, inside the BlocBuilder or wherever the state is handled:

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors
                    .backgroundChart, // Background color of the container
                borderRadius:
                    BorderRadius.circular(8), // Sets the border radius to 8
              ),
              child: BlocBuilder<RevenueBloc, RevenueState>(
                builder: (context, state) {
                  if (state is RevenueLoaded) {
                    // Ensure that there are at least 6 revenues, if not, take as many as there are
                    List<Revenue> firstSixRevenues = state.revenues.length > 6
                        ? state.revenues.sublist(0, 6)
                        : state.revenues;
                    return RevenueBarChart(revenues: firstSixRevenues);
                  } else if (state is RevenueLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return const Center(
                    child: Text('Chọn năm cần kiểm tra doanh thu.'),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors
                    .backgroundChart, // Background color of the container
                borderRadius:
                    BorderRadius.circular(8), // Sets the border radius to 8
              ),
              child: BlocBuilder<RevenueBloc, RevenueState>(
                builder: (context, state) {
                  if (state is RevenueLoaded) {
                    // Ensure that there are at least 6 revenues, if not, take as many as there are
                    List<Revenue> firstSixRevenues = state.revenues.length > 6
                        ? state.revenues.sublist(6, 12)
                        : state.revenues;
                    return RevenueBarChart(revenues: firstSixRevenues);
                  } else if (state is RevenueLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return const Center(
                    child: Text('Chọn năm cần kiểm tra doanh thu.'),
                  );
                },
              ),
            ),
          )
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
