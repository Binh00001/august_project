import 'dart:async';
import 'dart:typed_data';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_august/blocs/print_invoice_usb/print_invoice_image_usb_event.dart';
import 'package:flutter_project_august/blocs/print_invoice_usb/print_invoice_image_usb_state.dart';
import 'package:image/image.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';

class UsbPrintImageBloc extends Bloc<UsbPrintImageEvent, UsbPrintImageState> {
  final PrinterManager printerManager = PrinterManager.instance;
  StreamSubscription<USBStatus>? _subscriptionUsbStatus;
  List<PrinterDevice> devices = [];
  PrinterDevice? selectedPrinter;

  UsbPrintImageBloc() : super(UsbPrintImageInitial()) {
    on<PrintUsbImage>(_printUsbImage);
  }

  // Hàm quét các thiết bị USB
  Future<void> _scan(PrinterType type, {bool isBle = false}) async {
    devices.clear();

    await for (var device
        in printerManager.discovery(type: type, isBle: isBle)) {
      devices.add(device);
    }
  }

  // Hàm kết nối đến thiết bị USB đã chọn
  Future<void> _connectDevice(
      PrinterDevice selectedPrinter, PrinterType type) async {
    switch (type) {
      case PrinterType.usb:
        await printerManager.connect(
          type: type,
          model: UsbPrinterInput(
            name: selectedPrinter.name,
            productId: selectedPrinter.productId,
            vendorId: selectedPrinter.vendorId,
          ),
        );
        break;
      default:
        throw UnsupportedError("Loại máy in không được hỗ trợ");
    }
  }

  Future<void> _printUsbImage(
      PrintUsbImage event, Emitter<UsbPrintImageState> emit) async {
    emit(UsbPrintImageLoading());

    try {
      print(1);
      // Bước 1: Quét máy in USB
      await _scan(PrinterType.usb);
      print(2);
      print(devices);
      // Kiểm tra nếu có thiết bị USB nào được tìm thấy
      if (devices.isEmpty) {
        emit(const UsbPrintImageError("Không tìm thấy thiết bị USB"));
        return;
      }
      print(3);
      // Chọn thiết bị đầu tiên từ danh sách
      selectedPrinter = devices.first;
      print(4);
      // Bước 2: Kết nối máy in đã chọn
      await _connectDevice(selectedPrinter!, PrinterType.usb);
      emit(UsbPrintImageConnected());

      // Bước 3: Giải mã ảnh và in
      final Uint8List bytes = event.image;
      final Image? image = decodeImage(bytes);

      if (image != null) {
        final profile = await CapabilityProfile.load(name: 'XP-N160I');
        final generator = Generator(PaperSize.mm80, profile);
        List<int> printData = generator.imageRaster(image);
        printData += generator.feed(2);
        printData += generator.cut();

        printerManager.send(type: PrinterType.usb, bytes: printData);
        emit(UsbPrintImagePrinted());
      } else {
        emit(const UsbPrintImageError('Không giải mã được hình ảnh'));
      }
    } catch (e) {
      emit(UsbPrintImageError("Lỗi khi in ảnh: $e"));
    } finally {
      // Bước 4: Ngắt kết nối sau khi in xong
      await printerManager.disconnect(type: PrinterType.usb);
      emit(UsbPrintImageDisconnected());
    }
  }

  @override
  Future<void> close() {
    _subscriptionUsbStatus?.cancel();
    return super.close();
  }
}

class BluetoothPrinter {
  int? id;
  String? deviceName;
  String? address;
  String? port;
  String? vendorId;
  String? productId;
  bool? isBle;

  PrinterType typePrinter;
  bool? state;

  BluetoothPrinter(
      {this.deviceName,
      this.address,
      this.port,
      this.state,
      this.vendorId,
      this.productId,
      this.typePrinter = PrinterType.bluetooth,
      this.isBle = false});
}
