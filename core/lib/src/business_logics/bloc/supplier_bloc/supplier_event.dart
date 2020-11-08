part of 'supplier_bloc.dart';

abstract class SupplierEvent extends Equatable {
  const SupplierEvent();

  @override
  List<Object> get props => [];
}

class AddSupplier extends SupplierEvent {
  final String sname;
  final String scode;
  final String snum;
  final String saddress;
  final String saddate;

  AddSupplier({
    this.sname,
    this.scode,
    this.snum,
    this.saddress,
    this.saddate,
  });

  @override
  List<Object> get props => [sname, scode, snum, saddress, saddate];
}

class EditSupplier extends SupplierEvent {
  final String sname;
  final String scode;
  final String snum;
  final String saddress;
  final String saddate;

  EditSupplier({
    this.sname,
    this.scode,
    this.snum,
    this.saddress,
    this.saddate,
  });

  @override
  List<Object> get props => [sname, scode, snum, saddress, saddate];
}

class DeleteSupplier extends SupplierEvent {
  final String scode;

  DeleteSupplier({
    this.scode,
  });

  @override
  List<Object> get props => [];
}
