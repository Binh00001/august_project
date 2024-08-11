import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProducts extends ProductEvent {
  final int page;
  final int pageSize;
  final String? categoryId;
  final String? originId;

  const FetchProducts({
    required this.page,
    required this.pageSize,
    this.categoryId,
    this.originId,
  });

  @override
  List<Object> get props => [page, pageSize, categoryId ?? '', originId ?? ''];
}
