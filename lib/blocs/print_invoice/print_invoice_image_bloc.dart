import 'dart:async';
import 'dart:typed_data';
import 'package:esc_pos_printer_plus/esc_pos_printer_plus.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/print_invoice/print_invoice_image_event.dart';
import 'package:flutter_project_august/blocs/print_invoice/print_invoice_image_state.dart';
import 'package:flutter_project_august/database/share_preferences_helper.dart';
import 'package:image/image.dart';

class PrintInvoiceImageBloc
    extends Bloc<PrintInvoiceImageEvent, PrintInvoiceImageState> {
  PrintInvoiceImageBloc() : super(PrintInvoiceImageInitial()) {
    on<PrintImage>(_printImage);
  }

  Future<void> _printImage(
      PrintImage event, Emitter<PrintInvoiceImageState> emit) async {
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(PaperSize.mm80, profile);
    // Phát trạng thái "đang tải" trước khi thực hiện
    emit(PrintInvoiceImageLoading());
    try {
      String ip = await SharedPreferencesHelper.getPrinterIP();
      int portPrinter = await SharedPreferencesHelper.getPrinterPort();
      final PosPrintResult isConnected =
          await printer.connect(ip, port: portPrinter);
      if (isConnected != PosPrintResult.success) {
        // Nếu không thể kết nối với máy in, phát trạng thái lỗi
        emit(const PrintInvoiceImageError('Không thể kết nối đến máy in'));
        await Future.delayed(const Duration(seconds: 1), () {
          emit(PrintInvoiceImageInitial());
        });
        return;
      }

      final Uint8List bytes = event.image;
      final Image? image = decodeImage(bytes);

      if (image != null) {
        printer.imageRaster(image);
        printer.feed(2);
        printer.cut();
        printer.disconnect();
        emit(
            PrintInvoiceImageSuccess()); // Phát trạng thái thành công khi in hoàn tất
        await Future.delayed(const Duration(seconds: 1), () {
          emit(PrintInvoiceImageInitial());
        });
        // printer.disconnect();
      } else {
        // Nếu không giải mã được hình ảnh, phát trạng thái lỗi
        emit(PrintInvoiceImageError('Không giải mã được hình ảnh'));
        await Future.delayed(const Duration(seconds: 1), () {
          emit(PrintInvoiceImageInitial());
        });
      }
    } catch (e) {
      // Nếu có lỗi ngoại lệ xảy ra, phát trạng thái lỗi với thông điệp lỗi
      emit(PrintInvoiceImageError('Lỗi khi in hoá đơn: $e'));
      await Future.delayed(const Duration(seconds: 1), () {
        emit(PrintInvoiceImageInitial());
      });
    } finally {
      printer.disconnect(); // Đảm bảo ngắt kết nối máy in sau khi xử lý
    }
  }
}
