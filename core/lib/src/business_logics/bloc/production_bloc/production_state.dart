part of 'production_bloc.dart';

abstract class ProductionState {
  const ProductionState();
}

class ProductionIdle extends ProductionState {}

class ProductionLoading extends ProductionState {
  final bool status;
  final String message;

  ProductionLoading(this.status, this.message);
}

class ProductionSuccess extends ProductionState {
  final bool status;
  final String message;

  ProductionSuccess(this.status, this.message);
}

class ProductionError extends ProductionState {
  final bool status;
  final String message;

  ProductionError(this.status, this.message);
}

class ProductionErrorAndClear extends ProductionState {
  final bool status;
  final String message;

  ProductionErrorAndClear(this.status, this.message);
}
