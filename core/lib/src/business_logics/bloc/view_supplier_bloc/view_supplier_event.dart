part of 'view_supplier_bloc.dart';

abstract class ViewSupplierEvent {
  const ViewSupplierEvent();
  //
  // @override
  // List<Object> get props => [];
}

class FetchSupplierEvent extends ViewSupplierEvent {
  final String sname;
  final String scode;

  FetchSupplierEvent({
    this.sname,
    this.scode,
  });

  // @override
  // List<Object> get props => [sname];
}

class SearchAndFetchSupplierEvent extends ViewSupplierEvent {
  final String sname;
  final String scode;

  SearchAndFetchSupplierEvent({
    this.sname,
    this.scode,
  });

  // @override
  // List<Object> get props => [sname];
}
