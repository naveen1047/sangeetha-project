part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class AddEmployee extends EmployeeEvent {
  final String ename;
  final String ecode;
  final String enumber;
  final String eaddress;
  final String eaddate;

  AddEmployee({
    this.ename,
    this.ecode,
    this.enumber,
    this.eaddress,
    this.eaddate,
  });

  @override
  List<Object> get props => [ename, ecode, enumber, eaddress, eaddate];
}

class EditEmployee extends EmployeeEvent {
  final String ename;
  final String ecode;
  final String enumber;
  final String eaddress;
  final String eaddate;

  EditEmployee({
    this.ename,
    this.ecode,
    this.enumber,
    this.eaddress,
    this.eaddate,
  });

  @override
  List<Object> get props => [ename, ecode, enumber, eaddress, eaddate];
}

class DeleteEmployee extends EmployeeEvent {
  final String ecode;

  DeleteEmployee({
    this.ecode,
  });

  @override
  List<Object> get props => [];
}
