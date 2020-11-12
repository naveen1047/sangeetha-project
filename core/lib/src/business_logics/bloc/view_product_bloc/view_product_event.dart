part of 'view_product_bloc.dart';

abstract class ViewProductEvent extends Equatable {
  const ViewProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProductEvent extends ViewProductEvent {
  final String pname;
  final String pcode;

  FetchProductEvent({this.pname, this.pcode});

  @override
  List<Object> get props => [pname];
}

class SearchAndFetchProductEvent extends ViewProductEvent {
  final String pname;
  final String pcode;

  SearchAndFetchProductEvent({this.pname, this.pcode});

  @override
  List<Object> get props => [pname];
}

// sorting
class SortProductByName extends ViewProductEvent {}

class SortProductByNosProducedPerStroke extends ViewProductEvent {}

class SortProductBySalaryPerStroke extends ViewProductEvent {}

class SortProductBySellingUnit extends ViewProductEvent {}

class SortProductByPricePerSellingUnit extends ViewProductEvent {}

class SortProductByNosPerSellingUnit extends ViewProductEvent {}
