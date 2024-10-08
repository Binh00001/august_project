import 'dart:typed_data';
import 'package:equatable/equatable.dart';

import 'package:flutter_project_august/blocs/print_invoice_usb/print_invoice_image_usb_bloc.dart';

abstract class UsbPrintImageEvent extends Equatable {
  const UsbPrintImageEvent();
  @override
  List<Object?> get props => [];
}

class ConnectUsbPrinter extends UsbPrintImageEvent {
  final BluetoothPrinter printer;
  const ConnectUsbPrinter(this.printer);
}

class PrintUsbImage extends UsbPrintImageEvent {
  final Uint8List image;
  const PrintUsbImage(this.image);
}

class DisconnectUsbPrinter extends UsbPrintImageEvent {}
