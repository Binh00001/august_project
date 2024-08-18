import 'package:flutter/material.dart';
import 'package:flutter_project_august/models/order_model.dart';
import 'package:flutter_project_august/utill/color-theme.dart';
import 'package:intl/intl.dart';

class OrderDetailsPage extends StatefulWidget {
  final Order order;

  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: widget.order.orderItems.length,
          itemBuilder: (context, index) {
            final item = widget.order.orderItems[index];
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              margin: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                title: Text(item.productName),
                subtitle:
                    Text('Số lượng: ${item.quantity} (${item.productUnit})'),
                trailing: Text(
                  '${NumberFormat('#,##0', 'vi_VN').format(num.parse(item.price))} đ',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: widget.order.payStatus == "pending"
          ? BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    // // Hành động khi nút được nhấn
                    // markAsPaid();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.onPrimary,
                    backgroundColor: AppColors.primary, // Text and icon color
                  ),
                  child: const Text('Đánh dấu đã thanh toán'),
                ),
              ),
            )
          : null, // Không hiển thị nút nếu đã thanh toán
    );
  }
}
