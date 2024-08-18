import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/get_order/get_order_bloc.dart';
import 'package:flutter_project_august/blocs/get_order/get_order_event.dart';
import 'package:flutter_project_august/blocs/get_order/get_order_state.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_event.dart';
import 'package:flutter_project_august/blocs/school_bloc/school_state.dart';
import 'package:flutter_project_august/models/order_model.dart';
import 'package:flutter_project_august/models/school_model.dart';
import 'package:flutter_project_august/page/feature_page/order_detail.dart';
import 'package:flutter_project_august/utill/color-theme.dart';
import 'package:intl/intl.dart';

import '../../blocs/school_bloc/school_bloc.dart';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? selectedSchoolId;

  @override
  void initState() {
    super.initState();

    // Set _startDate and _endDate to today's date
    DateTime now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day);
    _endDate = DateTime(now.year, now.month, now.day)
        .add(const Duration(days: 1))
        .subtract(const Duration(microseconds: 1));

    // Add initial event to fetch orders with today's date
    BlocProvider.of<GetOrderBloc>(context, listen: false).add(
      FetchOrders(
          page: 1,
          pageSize: 10,
          schoolId: selectedSchoolId,
          startDate: _startDate!.millisecondsSinceEpoch,
          endDate: _endDate!.millisecondsSinceEpoch),
    );

    // Fetch list of schools
    BlocProvider.of<SchoolBloc>(context).add(GetAllSchoolsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
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
            const SizedBox(height: 16),
            BlocBuilder<SchoolBloc, SchoolState>(
              builder: (context, state) {
                if (state is SchoolLoading) {
                  return const CircularProgressIndicator();
                } else if (state is SchoolLoaded) {
                  return DropdownButtonFormField<String>(
                    value: selectedSchoolId,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSchoolId = newValue; // Cập nhật giá trị mới
                        fetchOrdersIfPossible(context);
                      });
                      // Thực hiện hành động nào đó khi chọn (cập nhật UI, gửi sự kiện,...)
                    },
                    decoration: InputDecoration(
                      labelText: 'Chọn trường học',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null, // Giá trị null cho lựa chọn "Tất cả"
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
            Expanded(
              child: BlocBuilder<GetOrderBloc, GetOrderState>(
                builder: (context, state) {
                  if (state is GetOrderLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetOrderLoaded) {
                    if (state.orders.isEmpty) {
                      // Nếu danh sách đơn hàng rỗng, hiển thị một thông báo
                      return const Center(
                        child: Text(
                          'Không có đơn',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    } else {
                      // Nếu danh sách không rỗng, xây dựng ListView để hiển thị đơn hàng
                      return ListView.builder(
                        itemCount: state.orders.length,
                        itemBuilder: (context, index) {
                          final order = state.orders[index];
                          return Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.userName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(order.schoolName),
                                      Text(
                                        order.payStatus == "pending"
                                            ? "Chưa thanh toán"
                                            : "Đã thanh toán",
                                        style: TextStyle(
                                          color: order.payStatus == "pending"
                                              ? AppColors.error
                                              : AppColors.onSuccess,
                                          fontWeight: FontWeight
                                              .bold, // Nếu cần, có thể thay đổi font weight
                                          fontSize:
                                              16, // Nếu cần, có thể thay đổi kích thước chữ
                                        ),
                                      ),
                                      Text(
                                          'Số mặt hàng: ${order.orderItems.length}'),
                                      Text(
                                        'Tổng tiền: ${NumberFormat('#,##0', 'vi_VN').format(num.parse(order.totalAmount))} đ',
                                        style: const TextStyle(
                                          color: AppColors.lightRed,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _showOrderDetails(order),
                                  child: const Icon(Icons.arrow_forward_ios,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  } else if (state is GetOrderError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return Container(); // Default empty container
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(Order order) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrderDetailsPage(order: order),
      ),
    );
  }

  void fetchOrdersIfPossible(BuildContext context) {
    if (_startDate != null && _endDate != null) {
      // Nếu cả ngày bắt đầu và ngày kết thúc đều không phải là null, gửi yêu cầu đầy đủ
      BlocProvider.of<GetOrderBloc>(context).add(FetchOrders(
          page: 1,
          pageSize: 10,
          startDate: _startDate!.millisecondsSinceEpoch,
          endDate: _endDate!.millisecondsSinceEpoch,
          schoolId: selectedSchoolId));
    } else {
      // Nếu một trong các ngày là null, chỉ sử dụng schoolId để gửi yêu cầu
      BlocProvider.of<GetOrderBloc>(context)
          .add(FetchOrders(page: 1, pageSize: 10, schoolId: selectedSchoolId));
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
            _endDate =
                null; // Optionally reset the end date if it is before the start date
          }
        } else {
          if (_startDate != null && picked.isBefore(_startDate!)) {
            return; // Optionally do nothing if the end date is before the start date
          }
          _endDate = picked;
        }

        // Check if both dates are selected before fetching data
        if (_startDate != null && _endDate != null) {
          BlocProvider.of<GetOrderBloc>(context).add(FetchOrders(
              page: 1,
              pageSize: 10,
              startDate: _startDate!.millisecondsSinceEpoch,
              endDate: _endDate!.millisecondsSinceEpoch,
              schoolId:
                  selectedSchoolId // Ensure this is correctly being captured elsewhere in your code
              ));
        }
      });
    }
  }
}
