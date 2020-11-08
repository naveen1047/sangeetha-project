part of 'employee_bloc.dart';

abstract class EmployeeState {
  const EmployeeState();
}

class EmployeeIdleState extends EmployeeState {}

class EmployeeSuccess extends EmployeeState {
  final bool status;
  final String message;

  EmployeeSuccess(this.status, this.message);
}

class EmployeeError extends EmployeeState {
  final bool status;
  final String message;

  EmployeeError(this.status, this.message);
}

class EmployeeErrorAndClear extends EmployeeState {
  final bool status;
  final String message;

  EmployeeErrorAndClear(this.status, this.message);
}

class EmployeeLoading extends EmployeeState {
  final bool status;
  final String message;

  EmployeeLoading(this.status, this.message);
}
