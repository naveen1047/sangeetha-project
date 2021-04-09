part of 'view_stock_details_bloc.dart';

abstract class ViewStockDetailsState /*extends Equatable*/ {
  const ViewStockDetailsState();

  // @override
  // List<Object> get props => [];
}

class ViewStockDetailsLoading extends ViewStockDetailsState {}

class ViewStockDetailsLoaded extends ViewStockDetailsState {
  final List<StockDetail> stocks;

  ViewStockDetailsLoaded(this.stocks);
}

class ViewStockDetailsError extends ViewStockDetailsState {
  final String message;

  ViewStockDetailsError(this.message);
}
