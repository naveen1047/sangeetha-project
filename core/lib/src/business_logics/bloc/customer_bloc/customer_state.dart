part of 'customer_bloc.dart';

abstract class CustomerState {
  const CustomerState();
}

class CustomerIdleState extends CustomerState {}

class CustomerLoading extends CustomerState {
  final bool status;
  final String message;

  CustomerLoading(this.status, this.message);
}

class CustomerSuccess extends CustomerState {
  final bool status;
  final String message;

  CustomerSuccess(this.status, this.message);
}

class CustomerError extends CustomerState {
  final bool status;
  final String message;

  CustomerError(this.status, this.message);
}

class CustomerErrorAndClear extends CustomerState {
  final bool status;
  final String message;

  CustomerErrorAndClear(this.status, this.message);
}
