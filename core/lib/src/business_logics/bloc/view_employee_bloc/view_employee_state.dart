part of 'view_employee_bloc.dart';

abstract class ViewEmployeeState {
  const ViewEmployeeState();
}

class ViewEmployeeLoading extends ViewEmployeeState {}

class ViewEmployeeLoaded extends ViewEmployeeState {
  final List<Employee> employees;

  ViewEmployeeLoaded(this.employees);
}

class ViewEmployeeError extends ViewEmployeeState {
  final String message;

  ViewEmployeeError(this.message);
}
