part of 'view_customer_bloc.dart';

abstract class ViewCustomerEvent {
  const ViewCustomerEvent();

  @override
  List<Object> get props => [];
}

class FetchCustomerEvent extends ViewCustomerEvent {
  final String cname;
  final String ccode;

  FetchCustomerEvent({
    this.cname,
    this.ccode,
  });

  @override
  List<Object> get props => [cname];
}

class SearchAndFetchCustomerEvent extends ViewCustomerEvent {
  final String cname;
  final String ccode;

  SearchAndFetchCustomerEvent({
    this.cname,
    this.ccode,
  });

  @override
  List<Object> get props => [cname];
}
