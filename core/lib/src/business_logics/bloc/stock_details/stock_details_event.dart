part of 'stock_details_bloc.dart';

abstract class StockDetailsEvent extends Equatable {
  const StockDetailsEvent();

  @override
  List<Object> get props => [];
}

class EditStock extends StockDetailsEvent {
  final String pcode;
  final String tstock;
  final String rstock;
  final String cstock;

  EditStock(this.pcode, this.tstock, this.rstock, this.cstock);
}
