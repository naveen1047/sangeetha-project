part of 'view_production_bloc.dart';

abstract class ViewProductionEvent extends Equatable {
  const ViewProductionEvent();

  @override
  List<Object> get props => [];
}

class FetchProductionEvent extends ViewProductionEvent {
  final String ename;
  final String ecode;

  FetchProductionEvent({this.ename, this.ecode});

  @override
  List<Object> get props => [ename];
}

class SearchAndFetchProductionEvent extends ViewProductionEvent {
  final String ename;
  // final String ecode;
  // final String pname;
  // final String billNo;

  SearchAndFetchProductionEvent({
    this.ename,
    // this.pname,
    // this.billNo,
    // this.ecode,
  });

  @override
  List<Object> get props => [ename];
}

// sorting
class SortProductionByDate extends ViewProductionEvent {}

class SortProductionByEName extends ViewProductionEvent {}

class SortProductionByPName extends ViewProductionEvent {}

class SortProductionBySalaryPS extends ViewProductionEvent {}

class SortProductionByNoOfS extends ViewProductionEvent {}

class SortProductionBySalary extends ViewProductionEvent {}
