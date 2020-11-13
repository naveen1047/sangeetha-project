part of 'customer_bloc.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object> get props => [];
}

class AddCustomer extends CustomerEvent {
  final String cname;
  final String ccode;
  final String cnum;
  final String caddress;
  final String caddate;

  AddCustomer({
    this.cname,
    this.ccode,
    this.cnum,
    this.caddress,
    this.caddate,
  });

  @override
  List<Object> get props => [cname, ccode, cnum, caddress, caddate];
}

class EditCustomer extends CustomerEvent {
  final String cname;
  final String ccode;
  final String cnum;
  final String caddress;
  final String caddate;

  EditCustomer({
    this.cname,
    this.ccode,
    this.cnum,
    this.caddress,
    this.caddate,
  });

  @override
  List<Object> get props => [cname, ccode, cnum, caddress, caddate];
}

class DeleteCustomer extends CustomerEvent {
  final String ccode;

  DeleteCustomer({
    this.ccode,
  });

  @override
  List<Object> get props => [];
}
