part of 'stock_details_bloc.dart';

abstract class StockDetailsState extends Equatable {
  const StockDetailsState();

  @override
  List<Object> get props => [];
}

class StockDetailsIdle extends StockDetailsState {}

class StockDetailsLoading extends StockDetailsState {
  final bool status;
  final String message;

  StockDetailsLoading(this.status, this.message);
}

class StockDetailsSuccess extends StockDetailsState {
  final bool status;
  final String message;

  StockDetailsSuccess(this.status, this.message);
}

class StockDetailsError extends StockDetailsState {
  final bool status;
  final String message;

  StockDetailsError(this.status, this.message);
}

class StockDetailsErrorAndClear extends StockDetailsState {
  final bool status;
  final String message;

  StockDetailsErrorAndClear(this.status, this.message);
}
