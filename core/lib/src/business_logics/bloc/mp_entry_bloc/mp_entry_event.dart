part of 'mp_entry_bloc.dart';

abstract class MPEvent extends Equatable {
  const MPEvent();

  @override
  List<Object> get props => [];
}

class UploadMPEntry extends MPEvent {
  final String mpcode;
  final String scode;
  final String date;
  final String billno;
  final String mcode;
  final String quantity;
  final String unitprice;
  final String price;
  final String remarks;

  UploadMPEntry({
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

class EditMP extends MPEvent {
  final String mpcode;
  final String scode;
  final String date;
  final String billno;
  final String mcode;
  final String quantity;
  final String unitprice;
  final String price;
  final String remarks;

  EditMP({
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

class DeleteMP extends MPEvent {
  final String mpcode;

  DeleteMP(this.mpcode);

  @override
  List<Object> get props => [mpcode];
}
