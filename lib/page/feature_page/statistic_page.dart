import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/get_statistic/statistic_bloc.dart';
import 'package:flutter_project_august/blocs/get_statistic/statistic_event.dart';
import 'package:flutter_project_august/blocs/get_statistic/statistic_state.dart';
import 'package:flutter_project_august/utill/color-theme.dart';
import 'package:intl/intl.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({Key? key}) : super(key: key);

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  @override
  void initState() {
    super.initState();

    // Get today's date at midnight
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    // Set _endDate to the end of today
    _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

    // Set _startDate to 30 days before today
    _startDate = today.subtract(const Duration(days: 30));

    // Correctly use _startDate and _endDate for fetching statistics
    BlocProvider.of<StatisticBloc>(context).add(FetchStatistic(
        startDate: _startDate!.millisecondsSinceEpoch,
        endDate: _endDate!.millisecondsSinceEpoch));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống Kê'),
        backgroundColor:
            AppColors.primary, // Assuming AppColors.primary is blue
        foregroundColor:
            AppColors.onPrimary, // Assuming AppColors.onPrimary is white
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildSelectStartAndEnd(context),
            Expanded(
              // Makes the SingleChildScrollView take up the remaining space
              child: buildStatisticalContent(),
            ),
          ],
        ),
      ),
    );
  }

  Row buildSelectStartAndEnd(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(context, isStart: true),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
            onTap: () => _selectDate(context, isStart: false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
    );
  }

  Future<void> _selectDate(BuildContext context,
      {required bool isStart}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isStart ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null; // Reset end date if it's before the start date
          }
        } else {
          if (_startDate != null && picked.isBefore(_startDate!)) {
            return; // Prevent setting an end date before the start date
          }
          _endDate = picked;
        }
      });

      // Dispatch event to fetch data if both dates are set
      if (_startDate != null && _endDate != null) {
        BlocProvider.of<StatisticBloc>(context).add(FetchStatistic(
            startDate: _startDate!.millisecondsSinceEpoch,
            endDate: _endDate!.millisecondsSinceEpoch));
      }
    }
  }

  Widget buildStatisticalContent() {
    return BlocBuilder<StatisticBloc, StatisticState>(
      builder: (context, state) {
        if (state is StatisticLoading) {
          // return const CircularProgressIndicator();
        } else if (state is StatisticLoaded) {
          if (state.data.products.isEmpty) {
            // Display a message when no products are available
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Không có hàng hoá nào được bán trong thời gian này",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          }

          // Calculate the total price
          final total = state.data.products
              .fold<double>(0, (sum, product) => sum + product.totalPrice);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.data.products.length +
                      1, // Add one more item for the footer
                  itemBuilder: (context, index) {
                    if (index == state.data.products.length) {
                      // This is the last item, which is the footer
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("-- HẾT --",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      );
                    } else {
                      // Normal list items
                      var product = state.data.products[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(
                            product.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Đơn giá: ${formatNumber(product.price)} đ"),
                              Text(
                                "Số lượng đã bán: ${formatNumber(product.totalQuantity)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Tổng tiền: ${formatNumber(product.totalPrice)} đ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.secondary,
                      width: 2.0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Tổng cộng: ${formatNumber(total)} đ",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        } else if (state is StatisticError) {
          return Text('Error: ${state.message}');
        }
        return const Text('Hãy chọn ngày muốn kiểm tra.');
      },
    );
  }

  String formatNumber(double number) {
    // Use NumberFormat with a custom pattern
    NumberFormat formatter = NumberFormat(
        "#,##0.###", 'en_US'); // Allows one decimal place if it's not zero
    String formatted = formatter.format(number);
    return formatted;
  }
}
