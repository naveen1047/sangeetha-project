part of 'supplier_bloc.dart';

abstract class SupplierState {
  const SupplierState();
}

class SupplierIdleState extends SupplierState {}

class SupplierLoading extends SupplierState {
  final bool status;
  final String message;

  SupplierLoading(this.status, this.message);
}

class SupplierSuccess extends SupplierState {
  final bool status;
  final String message;

  SupplierSuccess(this.status, this.message);
}

class SupplierError extends SupplierState {
  final bool status;
  final String message;

  SupplierError(this.status, this.message);
}

class SupplierErrorAndClear extends SupplierState {
  final bool status;
  final String message;

  SupplierErrorAndClear(this.status, this.message);
}
