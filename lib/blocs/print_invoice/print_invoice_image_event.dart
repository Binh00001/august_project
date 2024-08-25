import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class PrintInvoiceImageEvent extends Equatable {
  const PrintInvoiceImageEvent();
  @override
  List<Object> get props => [];
}

class PrintImage extends PrintInvoiceImageEvent {
  final Uint8List image;

  const PrintImage(this.image);

  @override
  List<Object> get props => [image];
}
