part of 'view_mp_bloc.dart';

abstract class ViewMPEvent extends Equatable {
  const ViewMPEvent();

  @override
  List<Object> get props => [];
}

class FetchMPEvent extends ViewMPEvent {
  final String mname;
  final String mcode;

  FetchMPEvent({this.mname, this.mcode});

  @override
  List<Object> get props => [mname];
}

class SearchAndFetchMPEvent extends ViewMPEvent {
  final String mname;
  final String mcode;
  final String sname;
  final String billNo;

  SearchAndFetchMPEvent({
    this.mname,
    this.sname,
    this.billNo,
    this.mcode,
  });

  @override
  List<Object> get props => [mname];
}

// sorting
class SortMPBySName extends ViewMPEvent {}

class SortMPByMName extends ViewMPEvent {}

class SortMPByBillNo extends ViewMPEvent {}

class SortMPByQuantity extends ViewMPEvent {}

class SortMPByUnit extends ViewMPEvent {}

class SortMPByTotal extends ViewMPEvent {}
