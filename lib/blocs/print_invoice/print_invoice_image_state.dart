import 'package:equatable/equatable.dart';

class PrintInvoiceImageState extends Equatable {
  const PrintInvoiceImageState();
  @override
  List<Object> get props => [];
}

class PrintInvoiceImageInitial extends PrintInvoiceImageState {}

class PrintInvoiceImageLoading extends PrintInvoiceImageState {}

class PrintInvoiceImageSuccess extends PrintInvoiceImageState {}

class PrintInvoiceImageError extends PrintInvoiceImageState {
  final String errorMessage;
  const PrintInvoiceImageError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
