import 'package:equatable/equatable.dart';

abstract class UsbPrintImageState extends Equatable {
  const UsbPrintImageState();
  @override
  List<Object?> get props => [];
}

class UsbPrintImageInitial extends UsbPrintImageState {}

class UsbPrintImageLoading extends UsbPrintImageState {}

class UsbPrintImageConnected extends UsbPrintImageState {}

class UsbPrintImagePrinted extends UsbPrintImageState {}

class UsbPrintImageDisconnected extends UsbPrintImageState {}

class UsbPrintImageError extends UsbPrintImageState {
  final String message;
  const UsbPrintImageError(this.message);
  @override
  List<Object?> get props => [message];
}
