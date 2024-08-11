import 'package:equatable/equatable.dart';

abstract class OriginEvent extends Equatable {
  const OriginEvent();

  @override
  List<Object> get props => [];
}

class FetchOrigins extends OriginEvent {
  const FetchOrigins();

  @override
  List<Object> get props => [];
}
