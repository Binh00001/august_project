// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/assets_widget/notification_dialog.dart';
import 'package:flutter_project_august/blocs/mark_paid_order/mark_paid_bloc.dart';
import 'package:flutter_project_august/blocs/mark_paid_order/mark_paid_event.dart';
import 'package:flutter_project_august/blocs/mark_paid_order/mark_paid_state.dart';
import 'package:flutter_project_august/blocs/print_invoice/print_invoice_image_bloc.dart';
import 'package:flutter_project_august/blocs/print_invoice/print_invoice_image_event.dart';
import 'package:flutter_project_august/blocs/print_invoice/print_invoice_image_state.dart';
import 'package:flutter_project_august/blocs/print_invoice_usb/print_invoice_image_usb_bloc.dart';
import 'package:flutter_project_august/blocs/print_invoice_usb/print_invoice_image_usb_event.dart';
import 'package:flutter_project_august/blocs/print_invoice_usb/print_invoice_image_usb_state.dart';
import 'package:flutter_project_august/database/share_preferences_helper.dart';
import 'package:flutter_project_august/models/order_model.dart';
import 'package:flutter_project_august/utill/color-theme.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailsPage extends StatefulWidget {
  final Order order;
  final String userRole;

  const OrderDetailsPage({
    Key? key,
    required this.order,
    required this.userRole,
  }) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  ScreenshotController screenshotController = ScreenshotController();
  String payStatus = "await";
  String _printerType = "usb"; // Initial printer type

  @override
  void initState() {
    super.initState();
    payStatus = widget.order.payStatus; // Khởi tạo giá trị ban đầu từ đơn hàng
    loadSettings();
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _printerType = prefs.getString('_printerType') ?? "usb";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<PrintInvoiceImageBloc, PrintInvoiceImageState>(
            listener: (context, state) {
              if (state is PrintInvoiceImageLoading) {
                // Show loading dialog
                showDialog(
                  context: context,
                  builder: (context) => const NotificationDialog(
                    iconDialog: Icons.print_rounded,
                    colorIconDialog: Colors.amber,
                    titleDialog: "Đang in hoá đơn qua Wifi",
                  ),
                );
              } else if (state is PrintInvoiceImageSuccess) {
                // Close loading dialog before showing success dialog
                Navigator.pop(context);
                // Show success dialog
                showDialog(
                  context: context,
                  builder: (context) => const NotificationDialog(
                    iconDialog: Icons.check_circle,
                    colorIconDialog: Colors.green,
                    titleDialog: "In thành công",
                  ),
                );
              } else if (state is PrintInvoiceImageError) {
                // Close loading dialog before showing error dialog
                Navigator.pop(context);
                // Show error dialog
                showDialog(
                  context: context,
                  builder: (context) => NotificationDialog(
                    iconDialog: Icons.error_rounded,
                    colorIconDialog: Colors.red,
                    titleDialog: state.errorMessage,
                  ),
                );
              }
            },
          ),
          BlocListener<UsbPrintImageBloc, UsbPrintImageState>(
            listener: (context, state) {
              if (state is UsbPrintImageLoading) {
                // Show loading dialog for USB printing
                showDialog(
                  context: context,
                  builder: (context) => const NotificationDialog(
                    iconDialog: Icons.print_rounded,
                    colorIconDialog: Colors.amber,
                    titleDialog: "Đang in qua USB",
                  ),
                );
              } else if (state is UsbPrintImagePrinted) {
                // Close loading dialog before showing success dialog
                Navigator.pop(context);
                // Show success dialog
                showDialog(
                  context: context,
                  builder: (context) => const NotificationDialog(
                    iconDialog: Icons.check_circle,
                    colorIconDialog: Colors.green,
                    titleDialog: "In qua USB thành công",
                  ),
                );
              } else if (state is UsbPrintImageError) {
                // Close loading dialog before showing error dialog
                Navigator.pop(context);
                // Show error dialog
                showDialog(
                  context: context,
                  builder: (context) => NotificationDialog(
                    iconDialog: Icons.error_rounded,
                    colorIconDialog: Colors.red,
                    titleDialog: state.message,
                  ),
                );
              }
            },
          ),
          BlocListener<MarkOrderBloc, MarkOrderState>(
            listener: (context, state) async {
              if (state is MarkOrderLoading) {
                // Show loading dialog for marking order as paid
                showDialog(
                  context: context,
                  builder: (context) => const NotificationDialog(
                    iconDialog: Icons.hourglass_empty,
                    colorIconDialog: Colors.amber,
                    titleDialog: "Đang xử lý...",
                  ),
                );
              } else if (state is MarkOrderPaidSuccess) {
                // Close loading dialog before showing success dialog
                Navigator.pop(context);
                // Show success dialog
                await showDialog(
                  context: context,
                  builder: (context) => const NotificationDialog(
                    iconDialog: Icons.check_circle,
                    colorIconDialog: Colors.green,
                    titleDialog: "Đã đánh dấu thanh toán",
                  ),
                ).then((_) {
                  setState(() {
                    payStatus = 'paid'; // Cập nhật biến phụ
                  });
                });
              } else if (state is MarkOrderPaidFailure) {
                // Close loading dialog before showing error dialog
                Navigator.pop(context);
                // Show error dialog
                showDialog(
                  context: context,
                  builder: (context) => NotificationDialog(
                    iconDialog: Icons.error_rounded,
                    colorIconDialog: Colors.red,
                    titleDialog: state.error,
                  ),
                );
              }
            },
          ),
        ],
        child: Padding(
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
                    'Đơn giá: ${NumberFormat('#,##0', 'vi_VN').format(num.parse(item.price))} đ',
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
      ),
      bottomNavigationBar:
          (widget.userRole == 'admin' || widget.userRole == 'staff')
              ? BottomAppBar(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (payStatus == "pending")
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<MarkOrderBloc>()
                                  .add(MarkOrderAsPaidEvent(widget.order.id));
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: AppColors.onPrimary,
                              backgroundColor: AppColors.primary,
                            ),
                            child: const Text('Đánh dấu đã thanh toán'),
                          ),
                        ElevatedButton(
                          onPressed: () {
                            _captureInvoiceImageThenPrint(widget.order);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('In đơn'),
                        ),
                      ],
                    ),
                  ),
                )
              : null,
    );
  }

  //capturing invoice image
  Future<void> _captureInvoiceImageThenPrint(Order order) async {
    screenshotController
        .captureFromLongWidget(
      InheritedTheme.captureAll(
        context,
        Material(
          child: generateInvoiceImage(order),
        ),
      ),
      pixelRatio: await SharedPreferencesHelper.getPrinterScale(),
      delay: const Duration(milliseconds: 100),
      context: context,
    )
        .then((capturedImage) {
      if (_printerType == "usb") {
        context.read<UsbPrintImageBloc>().add(PrintUsbImage(capturedImage));
      } else if (_printerType == "wifi") {
        context.read<PrintInvoiceImageBloc>().add(PrintImage(capturedImage));
      }
    });
  }

  Builder generateInvoiceImage(Order order) {
    return Builder(builder: (context) {
      final total = order.orderItems.fold<double>(
        0,
        (previousValue, element) =>
            previousValue +
            num.parse(element.price) * num.parse(element.quantity),
      );
      final DateTime date = DateTime.parse(order.createdAt);
      String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(date);
      return SizedBox(
        //chiều rộng 80mm
        width: 315,
        child: Column(
          children: [
            Column(
              children: [
                const Center(
                  child: Text(
                    'HOÁ ĐƠN BÁN HÀNG',
                    style: TextStyle(
                        // font: boldFont,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    'Số HĐ: ${order.id.length > 10 ? order.id.substring(order.id.length - 10) : order.id} \n',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                //thông tin khách hàng
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Khách hàng: ${order.userName == "" ? "Lỗi tên" : order.userName}\n'
                    'Trường học: ${order.schoolName}',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    order.status == 'pending'
                        ? 'Trạng thái: Chưa thanh toán \n'
                        : order.status == 'completed'
                            ? 'Trạng thái: Đã thanh toán \n'
                            : 'Trạng thái: ${order.status} \n',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: order.status == 'pending'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ngày tạo đơn: $formattedDate',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            Table(
              border: TableBorder.all(),
              columnWidths: const {
                //tối đa 315 pixel ~ 80mm
                0: FixedColumnWidth(175),
                1: FixedColumnWidth(55),
                2: FixedColumnWidth(85),
              },
              children: [
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4),
                      child: Center(
                        child: Text('Sản phẩm',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(4),
                      child: Center(
                        child: Text('SL',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text('Thành tiền',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10)),
                      ),
                    ),
                  ],
                ),
                ...order.orderItems.map(
                  (item) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item.productName} (${item.productUnit})',
                              style: const TextStyle(
                                  // font: lightFont,
                                  fontSize: 10),
                            ),
                            Text(
                              NumberFormat.decimalPattern()
                                  .format(num.parse(item.price)),
                              style: const TextStyle(
                                // font: lightFont,
                                fontSize: 10,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Center(
                          child: Text(
                            NumberFormat.decimalPattern()
                                .format(num.parse(item.quantity))
                                .toString(),
                            style: const TextStyle(
                                // font: lightFont,
                                fontSize: 10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            NumberFormat.decimalPattern().format(
                                num.parse(item.price) *
                                    num.parse(item.quantity)),
                            style: const TextStyle(
                                // font: lightFont,
                                fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 230,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text('Tổng tiền hàng:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          // fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right),
                  ),
                ),
                SizedBox(
                  width: 75,
                  child: Text(
                    NumberFormat.decimalPattern().format(
                        total), // Giả sử đây là tổng tiền hàng từ đối tượng order
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      // font: boldFont,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
