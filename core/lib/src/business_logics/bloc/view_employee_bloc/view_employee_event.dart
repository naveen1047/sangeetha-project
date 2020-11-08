part of 'view_employee_bloc.dart';

abstract class ViewEmployeeEvent extends Equatable {
  const ViewEmployeeEvent();

  @override
  List<Object> get props => [];
}

class FetchEmployeeEvent extends ViewEmployeeEvent {
  final String ename;
  final String ecode;

  FetchEmployeeEvent({
    this.ename,
    this.ecode,
  });

  @override
  List<Object> get props => [ename];
}

class SearchAndFetchEmployeeEvent extends ViewEmployeeEvent {
  final String ename;
  final String ecode;

  SearchAndFetchEmployeeEvent({
    this.ename,
    this.ecode,
  });

  @override
  List<Object> get props => [ename];
}
