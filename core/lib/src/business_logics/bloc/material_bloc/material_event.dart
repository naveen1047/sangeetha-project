part of 'material_bloc.dart';

abstract class MaterialEvent extends Equatable {
  const MaterialEvent();

  @override
  List<Object> get props => [];
}

class AddMaterial extends MaterialEvent {
  final String mname;
  final String mcode;
  final String munit;
  final String mpriceperunit;

  AddMaterial({
    this.mname,
    this.mcode,
    this.munit,
    this.mpriceperunit,
  });

  @override
  List<Object> get props => [
        mname,
        mcode,
        munit,
        mpriceperunit,
      ];
}

class EditMaterial extends MaterialEvent {
  final String mname;
  final String mcode;
  final String munit;
  final String mpriceperunit;

  EditMaterial({this.mname, this.mcode, this.munit, this.mpriceperunit});

  @override
  List<Object> get props => [
        mname,
        mcode,
        munit,
        mpriceperunit,
      ];
}

class DeleteMaterial extends MaterialEvent {
  final String mcode;

  DeleteMaterial({
    this.mcode,
  });

  @override
  List<Object> get props => [];
}
