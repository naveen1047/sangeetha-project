part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class AddProduct extends ProductEvent {
  final String pname;
  final String pcode;
  final String salaryps;
  final String nosps;
  final String sunit;
  final String pricepersunit;
  final String nospsunit;

  AddProduct({
    this.pname,
    this.pcode,
    this.salaryps,
    this.nosps,
    this.sunit,
    this.pricepersunit,
    this.nospsunit,
  });

  @override
  List<Object> get props => [
        pname,
        pcode,
        salaryps,
        nosps,
        sunit,
        pricepersunit,
        nospsunit,
      ];
}

class EditProduct extends ProductEvent {
  final String pname;
  final String pcode;
  final String salaryps;
  final String nosps;
  final String sunit;
  final String pricepersunit;
  final String nospsunit;

  EditProduct({
    this.pname,
    this.pcode,
    this.salaryps,
    this.nosps,
    this.sunit,
    this.pricepersunit,
    this.nospsunit,
  });

  @override
  List<Object> get props => [
        pname,
        pcode,
        salaryps,
        nosps,
        sunit,
        pricepersunit,
        nospsunit,
      ];
}

class DeleteProduct extends ProductEvent {
  final String pcode;

  DeleteProduct({
    this.pcode,
  });

  @override
  List<Object> get props => [];
}
