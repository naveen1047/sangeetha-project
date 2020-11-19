part of 'material_purchase_bloc.dart';

abstract class MaterialPurchaseEvent extends Equatable {
  const MaterialPurchaseEvent();

  @override
  List<Object> get props => [];
}

class FetchPrerequisite extends MaterialPurchaseEvent {}

class AddMaterialPurchase extends MaterialPurchaseEvent {
  final String mpcode;
  final String scode;
  final String date;
  final String billno;
  final String mcode;
  final String quantity;
  final String unitprice;
  final String price;
  final String remarks;

  AddMaterialPurchase({
    this.mpcode,
    this.scode,
    this.date,
    this.billno,
    this.mcode,
    this.quantity,
    this.unitprice,
    this.price,
    this.remarks,
  });

  @override
  List<Object> get props => [mpcode];
}

class EditMaterialPurchase extends MaterialPurchaseEvent {
  final String mpcode;
  final String scode;
  final String date;
  final String billno;
  final String mcode;
  final String quantity;
  final String unitprice;
  final String price;
  final String remarks;

  EditMaterialPurchase({
    this.mpcode,
    this.scode,
    this.date,
    this.billno,
    this.mcode,
    this.quantity,
    this.unitprice,
    this.price,
    this.remarks,
  });

  @override
  List<Object> get props => [mpcode];
}

class DeleteMaterialPurchase extends MaterialPurchaseEvent {
  final String scode;

  DeleteMaterialPurchase({
    this.scode,
  });

  @override
  List<Object> get props => [];
}
