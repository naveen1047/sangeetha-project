part of 'view_stock_details_bloc.dart';

abstract class ViewStockDetailsEvent extends Equatable {
  const ViewStockDetailsEvent();
}

class FetchStocksEvent extends ViewStockDetailsEvent {
  @override
  List<Object> get props => [];
}

class FetchStocksEventByPName extends ViewStockDetailsEvent {
  final String pname;

  FetchStocksEventByPName(this.pname);
  @override
  List<Object> get props => [];
}
