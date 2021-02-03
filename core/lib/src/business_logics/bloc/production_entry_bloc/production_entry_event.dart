part of 'production_entry_bloc.dart';

abstract class ProductionEvent extends Equatable {
  const ProductionEvent();

  @override
  List<Object> get props => [];
}

class ProductionEntry extends ProductionEvent {
  final String pdcode;
  final String date;
  final String pcode;
  final String ecode;
  final String sps;
  final String nos;
  final String nosps;
  final String salary;
  final String remarks;

  ProductionEntry({
    this.pdcode,
    this.date,
    this.pcode,
    this.ecode,
    this.sps,
    this.nos,
    this.nosps,
    this.salary,
    this.remarks,
  });

  @override
  List<Object> get props => [pdcode];
}

class EditProduction extends ProductionEvent {
  final String pdcode;
  final String date;
  final String pcode;
  final String ecode;
  final String sps;
  final String nos;
  final String nosps;
  final String salary;
  final String remarks;

  EditProduction({
    this.pdcode,
    this.date,
    this.pcode,
    this.ecode,
    this.sps,
    this.nos,
    this.nosps,
    this.salary,
    this.remarks,
  });

  @override
  List<Object> get props => [pdcode];
}

class DeleteProduction extends ProductionEvent {
  final String pdcode;

  DeleteProduction(this.pdcode);

  @override
  List<Object> get props => [pdcode];
}
