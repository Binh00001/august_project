import 'package:equatable/equatable.dart';

abstract class MarkOrderEvent extends Equatable {
  const MarkOrderEvent();

  @override
  List<Object?> get props => [];
}

class MarkOrderAsPaidEvent extends MarkOrderEvent {
  final String orderId;

  const MarkOrderAsPaidEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
