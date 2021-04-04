part of 'view_stock_details_bloc.dart';

abstract class ViewStockDetailsEvent extends Equatable {
  const ViewStockDetailsEvent();

  @override
  List<Object> get props => [];
}

class FetchStocksEvent extends ViewStockDetailsEvent {}

class FetchStocksEventByPName extends ViewStockDetailsEvent {
  final String pname;

  FetchStocksEventByPName(this.pname);
}

class SortStockByPName extends ViewStockDetailsEvent {}

class SortStockByLStock extends ViewStockDetailsEvent {}

class SortStockByRStock extends ViewStockDetailsEvent {}

class SortStockByTStock extends ViewStockDetailsEvent {}
